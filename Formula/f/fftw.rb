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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fd117eeb3d95627adacba7ac0acf898f85d0fb1abbcc9b2d3a4dd60e40de0d11"
    sha256 cellar: :any,                 arm64_sequoia: "f6a6799b0982ed9e7941d8e98061fd286a5062971d9b8d24ea5dbf31b16e01fe"
    sha256 cellar: :any,                 arm64_sonoma:  "e10f62334e9400d2206f97f27341f40a6a00313b3ba0841273719a378da72e92"
    sha256 cellar: :any,                 arm64_ventura: "7a199712be0d1f3f939bd6b87713bce221a971a478490be5f0b9ab7957fcdcf7"
    sha256 cellar: :any,                 sonoma:        "9da96486f698487496f226fac865a83be03898621e336030c9af62ff2330eff5"
    sha256 cellar: :any,                 ventura:       "51f48b1e29b2fdea49be26e90a65644ed6983839d565b0b071a9ac12f1cc2d6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05293e1ec5bbf794d245cb750566afe30bab65fbcae78b6201b109832a19691b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5508eb65401d0b5df3c9e8ebe3e8474a4d5b91e10e03132e4f5032008926fdcf"
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
