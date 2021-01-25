class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "http://www.fftw.org"
  url "http://fftw.org/fftw-3.3.9.tar.gz"
  sha256 "bf2c7ce40b04ae811af714deb512510cc2c17b9ab9d6ddcf49fe4487eea7af3d"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]

  livecheck do
    url "http://fftw.org/"
    regex(%r{latest official release.*? <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    cellar :any
    sha256 "ef292d79d65468ae63a095477d2ab12e562b2f3920d75e820152a0fc93a9b6a1" => :big_sur
    sha256 "06e4feb4413ac678d1dc9e8017fe86fd4a40ef114fca52d5145be2a4f182249b" => :arm64_big_sur
    sha256 "cdf77b713ee891041ed9ea057bca05439b086a5d640fe95e6021326b4aebf95b" => :catalina
    sha256 "ad960c339268de67c1d6086b0d205336d1f61a86db8fd7528b98e0d8acf98df5" => :mojave
  end

  depends_on "gcc"
  depends_on "open-mpi"

  fails_with :clang

  def install
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
    simd_args << "--enable-sse2" << "--enable-avx" if Hardware::CPU.intel?

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
    # http://www.fftw.org/fftw3_doc/Complex-One_002dDimensional-DFTs.html
    (testpath/"fftw.c").write <<~EOS
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
    EOS

    system ENV.cc, "-o", "fftw", "fftw.c", "-L#{lib}", "-lfftw3"
    system "./fftw"
  end
end
