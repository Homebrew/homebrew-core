class Clfft < Formula
  desc "FFT functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clFFT"
  url "https://github.com/clMathLibraries/clFFT/archive/v2.12.2.tar.gz"
  sha256 "e7348c146ad48c6a3e6997b7702202ad3ee3b5df99edf7ef00bbacc21e897b12"

  depends_on "boost" => :build
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "../src", "-DBUILD_EXAMPLES:BOOL=OFF", "-DBUILD_TEST:BOOL=OFF", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "src/examples"
  end

  test do
    system ENV.cxx, pkgshare/"examples/fft1d.c", "-I#{include}", "-L#{lib}",
                    "-lclFFT", "-framework", "OpenCL", "-o", "fft1d"
    assert_match "one dimensional array of size N = 16", shell_output("./fft1d")
  end
end
