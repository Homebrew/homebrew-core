class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "http://www.fftw.org"
  url "http://fftw.org/fftw-3.3.8.tar.gz"
  sha256 "6113262f6e92c5bd474f2875fa1b01054c4ad5040f6b0da7c03c98821d9ae303"

  bottle do
    cellar :any
    sha256 "79b08a5da9b091c43d4fdaabd73ecb6e4dba6525598d376d7d74bdf5d1183acc" => :high_sierra
    sha256 "17f2f88898b2754adb35f19857cd7c80966299fcdf2158cc1466b054deaa460e" => :sierra
    sha256 "a94c5f646948f918e986ab0be56672ac52f527debe1ed4cc783fd1ba6c99fe73" => :el_capitan
  end

  option "with-openmp", "Enable OpenMP parallel transforms"
  option "without-fortran", "Disable Fortran bindings"

  depends_on "cmake" => :build
  depends_on "gcc" if build.with?("fortran") || build.with?("openmp")
  fails_with :clang if build.with? "openmp"

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=on"
    args << "-DBUILD_TESTS=off"
    args << "-DENABLE_THREADS=on"

    simd_args = ["-DENABLE_SSE2=on"]
    simd_args << "-DENABLE_AVX=on" if ENV.compiler == :clang && Hardware::CPU.avx? && !build.bottle?
    simd_args << "-DENABLE_AVX2=on" if ENV.compiler == :clang && Hardware::CPU.avx2? && !build.bottle?

    args << "-DDISABLE_FORTRAN=on" if build.without? "fortran"
    args << "-DENABLE_OPENMP=on" if build.with? "openmp"

    ## long double precision
    ## no SIMD optimization available
    system "cmake", ".", "-DENABLE_FLOAT=off", "-DENABLE_LONG_DOUBLE=on", "-DENABLE_QUAD_PRECISION=off", *args
    system "make", "install"

    ## clean up so we can compile other variant
    system "make", "clean"

    ## default(double) precision
    ## enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "cmake", ".", "-DENABLE_FLOAT=off", "-DENABLE_LONG_DOUBLE=off", "-DENABLE_QUAD_PRECISION=off", *(args + simd_args)
    system "make", "install"

    ## clean up so we can compile other variant
    system "make", "clean"

    ## single precision
    ## enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "cmake", ".", "-DENABLE_FLOAT=on", "-DENABLE_LONG_DOUBLE=off", "-DENABLE_QUAD_PRECISION=off", *(args + simd_args)
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
