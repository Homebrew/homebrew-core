class Flexiblas < Formula
  desc "BLAS and LAPACK wrapper library with runtime exchangable backends"
  homepage "https://www.mpi-magdeburg.mpg.de/projects/flexiblas"
  url "https://csc.mpi-magdeburg.mpg.de/mpcsc/software/flexiblas/flexiblas-3.4.4.tar.xz"
  sha256 "f3b4db7175f00434b1ad1464c0fd004f9b9ddf4ef8d78de5a75382a1f73a75dd"
  license all_of: [
    "LGPL-3.0-or-later",
    "LGPL-2.1-or-later", # libcscutils/
    "BSD-3-Clause-Open-MPI", # contributed/
  ]
  head "https://gitlab.mpi-magdeburg.mpg.de/software/flexiblas-release.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?flexiblas[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "85c5e7cc7cb883d37d387adb373ff940259e07e71e5d3dde745aee51b657ec8d"
    sha256 arm64_sonoma:   "144a287222ffe00ffc4c12190a63b3da143f4f1392de28a00caf3386ead4d3d8"
    sha256 arm64_ventura:  "082787d3a84f8c9cc680c8c06d4ec26f7b3c09f0af57b00e3babac0d63bac2c1"
    sha256 arm64_monterey: "0d582036b81e7b61e9b8df071569ff2c3eb856b1f94f32159d6835411ee8e150"
    sha256 sonoma:         "548e8910615427d94a6d3585ae53a6759a00af6ef70811b3b5c3713cd23a57bd"
    sha256 ventura:        "4723c25e4e8f206f0bfe2c0d373ba24ec0827f0f0bb026e999994e003fd2a5de"
    sha256 monterey:       "166ec9738f3faa20546e6cc0a7ea69ce657026450d80acd3df5d3c4df060cd2a"
    sha256 x86_64_linux:   "e8286f52769a07dbcaf7dc0d3845e46b63d5c2c31ce516828e612eef952dcd81"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  on_macos do
    depends_on "libomp" => :build
  end

  fails_with :gcc do
    version "11"
    cause "Need to build with same GCC as GFortran for LTO"
  end

  def blas_backends
    backends = %w[OPENBLASOPENMP NETLIB]
    on_sonoma :or_newer do
      backends.unshift("APPLE")
    end
    on_ventura :or_older do
      backends << "APPLE"
    end
    backends
  end

  def install
    # Remove -flat_namespace usage
    inreplace "src/fallback_blas/CMakeLists.txt", " -flat_namespace\"", '"'

    # Add HOMEBREW_PREFIX path to default searchpath to allow detecting separate formulae
    inreplace "CMakeLists.txt",
              %r{(FLEXIBLAS_DEFAULT_LIB_PATH "\${CMAKE_INSTALL_FULL_LIBDIR}/\${flexiblasname}/)"},
              "\\1:#{HOMEBREW_PREFIX}/lib/${flexiblasname}\""

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFLEXIBLAS_DEFAULT=#{blas_backends.first}
      -DSYSCONFDIR=#{etc}
      -DEXAMPLES=OFF
      -DTESTS=OFF
      -DATLAS=OFF
      -DBlisSerial=OFF
      -DBlisPThread=OFF
      -DBlisOpenMP=OFF
      -DMklSerial=OFF
      -DMklOpenMP=OFF
      -DMklTBB=OFF
    ]

    etc_before = etc.glob("flexiblasrc.d/*")

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Let brew manage linking/deleting config files that are intended to be read-only
    (prefix/"etc/flexiblasrc.d").install (etc.glob("flexiblasrc.d/*") - etc_before)
  end

  def caveats
    <<~EOS
      FlexiBLAS includes the following backends: #{blas_backends.join(", ")}
      #{blas_backends.first} has been set as the default in #{etc}/flexiblasrc
    EOS
  end

  test do
    assert_match "Active Default: #{blas_backends.first} (System)", shell_output("#{bin}/flexiblas print")

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>

      #include <cblas.h>
      #include <flexiblas_api.h>

      int main(void) {
        printf("Current loaded backend: ");
        flexiblas_print_current_backend(stdout);

        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/flexiblas", "-L#{lib}", "-lflexiblas", "-o", "test"

    blas_backends.each do |backend|
      expected = <<~EOS
        Current loaded backend: #{backend}
        11.000000 -9.000000 5.000000 -9.000000 21.000000 -1.000000 5.000000 -1.000000 3.000000
      EOS
      with_env(FLEXIBLAS: backend) do
        assert_equal expected.strip, shell_output("./test").strip
      end
    end
  end
end
