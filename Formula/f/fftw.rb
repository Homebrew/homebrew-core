class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "https://fftw.org"
  url "https://fftw.org/fftw-3.3.10.tar.gz"
  sha256 "56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  revision 3

  livecheck do
    url :homepage
    regex(%r{latest official release.*? <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5cd394c2c385450a83f767935d5d6678aa5a8fb1eb6c687b26477370a881cb5f"
    sha256 cellar: :any,                 arm64_sequoia: "09266ec049017eb0e54ee29249d66e44bde84081f7379a683acaba378c2834e8"
    sha256 cellar: :any,                 arm64_sonoma:  "fffda09169aeed7f83343d88e8d7abe0f33c436fa3aa34a18c59093009aba067"
    sha256 cellar: :any,                 sonoma:        "01d05e976e388312e41888856168f914c0c0e0fd4fd628cdc4159dbb25a614db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0518314dfcdfbc7926812980da07121706708ffda83cf0f600df909945d4a4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062535068e14404ec86b816c0c1987d9d90213d05c27cfaaa9767c22c7c8b636"
  end

  depends_on "open-mpi"

  on_macos do
    depends_on "libomp"
  end

  # Fix the cmake config file when configured with autotools, upstream pr ref, https://github.com/FFTW/fftw3/pull/338
  patch do
    url "https://github.com/FFTW/fftw3/commit/394fa85ab5f8914b82b3404844444c53f5c7f095.patch?full_index=1"
    sha256 "2f3c719ad965b3733e5b783a1512af9c2bd9731bb5109879fbce5a76fa62eb14"
  end

  def install
    if OS.mac?
      ENV["OPENMP_CFLAGS"] = "-Xpreprocessor -fopenmp"
      ENV.append "LDFLAGS", "-lomp -Wl,-dead_strip_dylibs"
    end

    # FFTW supports runtime detection of CPU capabilities, so it is safe to
    # use with --enable-avx and the code will still run on all CPUs
    ENV.runtime_cpu_detection
    simd_args = []
    simd_args += %w[--enable-sse2 --enable-avx --enable-avx2] if Hardware::CPU.intel?

    common_args = %w[
      --enable-shared
      --enable-threads
      --enable-mpi
      --enable-openmp
    ]
    # Not default yet: https://github.com/FFTW/fftw3/pull/315#issuecomment-2630106315
    common_args << "--enable-armv8-cntvct-el0" if Hardware::CPU.arm64?

    # enable-sse2, enable-avx and enable-avx2 work for both single and double precision.
    # long-double precision has no SIMD optimization available.
    {
      "single"      => ["--enable-single", *simd_args],
      "double"      => simd_args,
      "long-double" => ["--enable-long-double"],
    }.each do |precision, args|
      mkdir "build-#{precision}" do
        system "../configure", *args, *common_args, *std_configure_args
        system "make", "install"
      end
    end
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
