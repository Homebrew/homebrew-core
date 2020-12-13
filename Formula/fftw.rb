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
    sha256 "d1713d61acb8e3f52098f69572c51c695393f33cb0d11032abc672a7e83a5977" => :big_sur
    sha256 "e021f210b7f8a785b86b82fe191408d783def6e6baec192e8133d703c51bf0de" => :catalina
    sha256 "d4af1ee10e2eb5784874cac832f10d3e8d3010962e31102df7c6bffc34783d92" => :mojave
    sha256 "64d050b8736eed9b127f175d39d4acc93c1ec960b096aee756bbb5ea906b6b82" => :high_sierra
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
    simd_args = ["--enable-sse2", "--enable-avx"]

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

    system ENV.cc, "-o", "fftw", "fftw.c", "-L#{lib}", "-lfftw3", *ENV.cflags.to_s.split
    system "./fftw"
  end
end
