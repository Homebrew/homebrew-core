class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "https://fftw.org"
  url "https://fftw.org/fftw-3.3.10.tar.gz"
  sha256 "56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]

  livecheck do
    url :homepage
    regex(%r{latest official release.*? <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9cb944fcc0ac1d3d62e19f425d76c4442f27391fc730d8e18023347d5a40c27f"
    sha256 cellar: :any,                 arm64_big_sur:  "bad8b35844e916b0aee957da5f50f1aaf42c400582ca9e0c531d8b1d7cbf831c"
    sha256 cellar: :any,                 monterey:       "e8381fd5cc57822cb5f87487633a88b0f71846dc188cdee3059d6da50751a653"
    sha256 cellar: :any,                 big_sur:        "7f8815d58971d1c38465556b12b2fc2cdd5c1575174984a493080cbb88efb925"
    sha256 cellar: :any,                 catalina:       "6189ebccb8f84d6aaf8139f877a0fed20605b749404b5e5296c2a673df681841"
    sha256 cellar: :any,                 mojave:         "694f17490cf119dba54c4ab36fe4c777d916fade8629cc1a728ff2f698c135b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9857c06bfd9eb89821aec3fe7a5a47283291ef9994b3167e8bbdb7e1f42784c2"
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
