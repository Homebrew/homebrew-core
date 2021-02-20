class Libfftw2 < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "http://www.fftw.org"
  url "http://www.fftw.org/fftw-2.1.5.tar.gz"
  sha256 "f8057fae1c7df8b99116783ef3e94a6a44518d49c72e2e630c24b689c6022630"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]

  def install
    args = [
      "--enable-shared",
      "--disable-debug",
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--enable-threads",
      "--disable-dependency-tracking",
      "--enable-mpi",
      "--enable-openmp",
    ]

    # FFTW supports runtime detection of CPU capabilities, so it is safe to
    # use with --enable-avx and the code will still run on all CPUs
    simd_args = []
    simd_args << "--enable-sse2" << "--enable-avx" if Hardware::CPU.intel?

    # double precision
    # enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "./configure", *(args + simd_args)
    system "make", "-j#{ENV.make_jobs}", "install"

    # clean up so we can compile the long-double precision variant
    system "make", "clean"

    # long-double precision
    # no SIMD optimization available
    system "./configure", "--enable-long-double", *args
    system "make", "-j#{ENV.make_jobs}", "install"

    # single precision
    # enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "./configure", "--enable-float", "--enable-type-prefix=s", *(args + simd_args)
    system "make", "-j#{ENV.make_jobs}", "install"

    # clean up so we can compile the double precision variant
    system "make", "clean"
  end

  test do
    assert_match "fftw/fftw.h.", shell_output("cat #{include}/fftw.h")
  end
end
