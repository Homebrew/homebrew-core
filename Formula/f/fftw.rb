class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "https://fftw.org"
  url "https://fftw.org/fftw-3.3.10.tar.gz"
  sha256 "56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  revision 2

  livecheck do
    url :homepage
    regex(%r{latest official release.*? <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a89853940caaca128e46545d3999540ea0723767c8ef8245db8f2419a1b2565"
    sha256 cellar: :any,                 arm64_sonoma:  "a1105be9ac0dd78978175a1b07b8ef429bf3d3c9074ad39a128fe5f01b910feb"
    sha256 cellar: :any,                 arm64_ventura: "32a67cfa0e6452c6a8cba5ab8f0cf337ef1f3cb1f55125443332b930c7a307d7"
    sha256 cellar: :any,                 sonoma:        "8b8af4f154be3b186932fd0050840760227958399093cee5241455194faf7505"
    sha256 cellar: :any,                 ventura:       "70d0f25e977df25d22f29010ccfb0c4be49438f0b35f525acff56fa7f29c15dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd7685235ce26f62a06f3b227658415d0ec0899885a05e1e4bd827262907b2bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d30800e3ad1513ceb764c62303bb2011a04256a0080b13f9e7803cfc1a4fa43"
  end

  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang

  # Fix the cmake config file when configured with autotools, upstream pr ref, https://github.com/FFTW/fftw3/pull/338
  patch do
    url "https://github.com/FFTW/fftw3/commit/394fa85ab5f8914b82b3404844444c53f5c7f095.patch?full_index=1"
    sha256 "2f3c719ad965b3733e5b783a1512af9c2bd9731bb5109879fbce5a76fa62eb14"
  end

  def install
    ENV.runtime_cpu_detection

    args = [
      "--enable-shared",
      "--disable-debug",
      "--prefix=#{prefix}",
      "--enable-threads",
      "--disable-dependency-tracking",
      "--enable-mpi",
      "--enable-openmp",
    ]

    # FFTW supports runtime detection of CPU capabilities, so it is safe to
    # use with --enable-avx and the code will still run on all CPUs
    simd_args = []
    simd_args += %w[--enable-sse2 --enable-avx --enable-avx2] if Hardware::CPU.intel?

    # single precision
    # enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "./configure", "--enable-single", *(args + simd_args)
    system "make", "install"

    # clean up so we can compile the double precision variant
    system "make", "clean"

    # double precision
    # enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "./configure", *(args + simd_args)
    system "make", "install"

    # clean up so we can compile the long-double precision variant
    system "make", "clean"

    # long-double precision
    # no SIMD optimization available
    system "./configure", "--enable-long-double", *args
    system "make", "install"
  end

  test do
    # Adapted from the sample usage provided in the documentation:
    # https://www.fftw.org/fftw3_doc/Complex-One_002dDimensional-DFTs.html
    (testpath/"fftw.c").write <<~C
      #include <fftw3.h>
      int main(int argc, char* *argv)
      {
          fftw_complex *in, *out;
          fftw_plan p;
          long N = 1;
          in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
          out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
          p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
          fftw_execute(p); /* repeat as needed */
          fftw_destroy_plan(p);
          fftw_free(in); fftw_free(out);
          return 0;
      }
    C

    system ENV.cc, "-o", "fftw", "fftw.c", "-L#{lib}", "-lfftw3"
    system "./fftw"
  end
end
