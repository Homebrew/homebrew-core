class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "http://www.fftw.org"
  url "http://fftw.org/fftw-3.3.8.tar.gz"
  sha256 "6113262f6e92c5bd474f2875fa1b01054c4ad5040f6b0da7c03c98821d9ae303"

  bottle do
    cellar :any
    sha256 "9de0f472ee7346aca3d44e10c94f4c3fcb89f0c3ba223aaaa530a4a3d9234980" => :mojave
    sha256 "79b08a5da9b091c43d4fdaabd73ecb6e4dba6525598d376d7d74bdf5d1183acc" => :high_sierra
    sha256 "17f2f88898b2754adb35f19857cd7c80966299fcdf2158cc1466b054deaa460e" => :sierra
    sha256 "a94c5f646948f918e986ab0be56672ac52f527debe1ed4cc783fd1ba6c99fe73" => :el_capitan
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
    simd_args = ["--enable-sse2"]

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
