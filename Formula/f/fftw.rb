class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "https://fftw.org"
  url "https://fftw.org/fftw-3.3.10.tar.gz"
  sha256 "56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  revision 1

  livecheck do
    url :homepage
    regex(%r{latest official release.*? <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f118b9b10a302aaa0a937b9c3004a1610a522f365022ab12e90e7ee929823ff4"
    sha256 cellar: :any,                 arm64_monterey: "ac39928c08c6cec08f61b31c37ea69be21f6020c5c50bbdc66751fc1907ee600"
    sha256 cellar: :any,                 arm64_big_sur:  "de50d4cd3e5de39ccbc168a8eb8555f9e36609198c9e4f91c1d1da122674d066"
    sha256 cellar: :any,                 ventura:        "31e8c75b13d33a17164163f3c5f5bb6605e26b2328a617696b0fae5aa08e8ad4"
    sha256 cellar: :any,                 monterey:       "dc7a704928be8c4724db42be3161aebf3f0d3b8e0f79e893bc1b294aed4ca770"
    sha256 cellar: :any,                 big_sur:        "bd3ae1b553913b3b627bd1af592d84da4c6a93e45dde5af4df7c393564b0f174"
    sha256 cellar: :any,                 catalina:       "f2b0548dfd646545af732cb6ee7f1d58c1950067e4f7fd558655fb388e464897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2b552eb0c8d31f577713c2e39ed6a22bd430d30d430d242767f253057839dca"
  end

  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang

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
