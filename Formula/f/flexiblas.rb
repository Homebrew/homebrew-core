class Flexiblas < Formula
  desc "BLAS and LAPACK wrapper library with runtime exchangable backends"
  homepage "https://www.mpi-magdeburg.mpg.de/projects/flexiblas"
  url "https://csc.mpi-magdeburg.mpg.de/mpcsc/software/flexiblas/flexiblas-3.4.5.tar.xz"
  sha256 "626b698bb73877019d64cf258f853885d28d3c6ac820ccd2c1a77fb7542a34a0"
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
    sha256 arm64_sequoia: "81a6bd02a4470c49a02bb0ba140bd5c00ec38059d663b898fd5e94d8beca4aa5"
    sha256 arm64_sonoma:  "89310043062ecb77eeb2da42028a1c0eb897d7466074b793987b946b149b64ec"
    sha256 arm64_ventura: "0bb756b92366da37fb73d75a4d1b12ab88c5f093cd586f714a2ae03dcfda7a04"
    sha256 sonoma:        "ea77b40631ddeef92fb906dc36a03bdbf5a2d0f814c88b7cb86be444f346fcb1"
    sha256 ventura:       "acc87e21dc68cd426558496c53782a3c29da31620e6a74a61009679c5aa3b2a9"
    sha256 arm64_linux:   "004f69a6c177117f133ff5c1d51253a702b593b8a954def07fcc2415b3038cc6"
    sha256 x86_64_linux:  "7ef88457713b30a28faf7491cf78686d301c680bf520e47ec570a8116260b923"
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

  # 3.4.5 build patch, upstream commit ref, https://gitlab.mpi-magdeburg.mpg.de/software/flexiblas-release/-/commit/80e00aaca18857ea02e255e88f1f282580940661
  patch do
    url "https://raw.githubusercontent.com/chenrui333/homebrew-tap/f6261b3c60d3fb6fa1d464a6ad13e0639e96e67e/patches/flexiblas/3.4.5.patch"
    sha256 "5f0d5a6e293aba60b4692739b9c3fa09985068682ffa81f0814d90a83d12868f"
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
