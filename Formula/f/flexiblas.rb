class Flexiblas < Formula
  desc "BLAS and LAPACK wrapper library with runtime exchangable backends"
  homepage "https://www.mpi-magdeburg.mpg.de/projects/flexiblas"
  url "https://csc.mpi-magdeburg.mpg.de/mpcsc/software/flexiblas/flexiblas-3.5.0.tar.xz"
  sha256 "504c0eeac09dca98e4bc930757f44bc409cb770f8fa7578ddb18c0d6accba072"
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
    sha256               arm64_tahoe:   "05bba3927380ff8a265da10c84f569fff2cd132e187afded0faeb69059f04fd3"
    sha256               arm64_sequoia: "8cb09438e43dfd0ee600bcd458e5355bd9de97deb9a5d21682c840b6d35acce3"
    sha256               arm64_sonoma:  "f3160f603ca0154101be20031c70edff5f7ec323330dd2f955bb73894cda1002"
    sha256 cellar: :any, sonoma:        "9c533f075296f83a0206f08691730068aea716c7c7eadce83b8b620c5889be04"
    sha256               arm64_linux:   "8cc351182c7d5553aedb9b2f7f2863cab2a063af8a76fbc4f1f0a1c5cd29e5db"
    sha256               x86_64_linux:  "b1d9f77c9b2c2a2bff3c464d43eadae6e156e435edb14bfda308b13df042ecdf"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  def blas_backends
    backends = %w[OpenBLASOpenMP NETLIB]
    on_sonoma :or_newer do
      backends.unshift("APPLE")
    end
    on_ventura :or_older do
      backends << "APPLE"
    end
    backends
  end

  def install
    # Need to build with same GCC as GFortran for LTO on Linux
    ENV["HOMEBREW_CC"] = Formula["gcc"].opt_bin/"gcc-#{Formula["gcc"].version.major}" if OS.linux?

    # Remove -flat_namespace usage
    flat_namespace_files = %w[
      src/fallback_blas/CMakeLists.txt
      src/fallback_lapack/CMakeLists.txt
      src/hooks/dummy/CMakeLists.txt
      src/hooks/profile/CMakeLists.txt
    ]
    inreplace flat_namespace_files, " -flat_namespace\"", '"'

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib/"flexiblas")}
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Let brew manage linking/deleting config files that are intended to be read-only
    blas_backends.each { |backend| (prefix/"etc/flexiblasrc.d").install etc/"flexiblasrc.d/#{backend}.conf" }
  end

  def caveats
    <<~EOS
      FlexiBLAS includes the following backends: #{blas_backends.join(", ")}
      #{blas_backends.first} has been set as the default in #{etc}/flexiblasrc
    EOS
  end

  test do
    assert_match "Active Default: #{blas_backends.first.upcase} (System)", shell_output("#{bin}/flexiblas print")

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
        Current loaded backend: #{backend.upcase}
        11.000000 -9.000000 5.000000 -9.000000 21.000000 -1.000000 5.000000 -1.000000 3.000000
      EOS
      with_env(FLEXIBLAS: backend) do
        assert_equal expected.strip, shell_output("./test").strip
      end
    end
  end
end
