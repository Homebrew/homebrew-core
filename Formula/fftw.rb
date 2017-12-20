class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "http://www.fftw.org"
  url "http://fftw.org/fftw-3.3.7.tar.gz"
  sha256 "3b609b7feba5230e8f6dd8d245ddbefac324c5a6ae4186947670d9ac2cd25573"

  bottle do
    cellar :any
    sha256 "7c6d0f9133c5b491fe5538edd7a073d730cda6a7ce097c206a9372054505f123" => :high_sierra
    sha256 "0682cdd73c692d6bb9e8ced37a94d1a39297546a110243ae9d6007870c46c52e" => :sierra
    sha256 "a4bd0dfab078a5c5cd98166947e6537e393964bfbe68c82a8912e42333bea8f3" => :el_capitan
  end

  option "with-mpi", "Enable MPI parallel transforms"
  option "with-openmp", "Enable OpenMP parallel transforms"

  depends_on :fortran => :recommended
  depends_on :mpi => [:cc, :optional]

  needs :openmp if build.with? "openmp"

  def install
    args = ["--enable-shared",
            "--disable-debug",
            "--prefix=#{prefix}",
            "--enable-threads",
            "--disable-dependency-tracking"]
    simd_args = ["--enable-sse2"]
    simd_args << "--enable-avx" if ENV.compiler == :clang && Hardware::CPU.avx? && !build.bottle?
    simd_args << "--enable-avx2" if ENV.compiler == :clang && Hardware::CPU.avx2? && !build.bottle?

    args << "--disable-fortran" if build.without? "fortran"
    args << "--enable-mpi" if build.with? "mpi"
    args << "--enable-openmp" if build.with? "openmp"

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
