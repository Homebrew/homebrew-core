class Clfft < Formula
  desc "FFT functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clFFT"
  url "https://github.com/clMathLibraries/clFFT/archive/v2.12.2.tar.gz"
  sha256 "e7348c146ad48c6a3e6997b7702202ad3ee3b5df99edf7ef00bbacc21e897b12"

  bottle do
    cellar :any
    sha256 "419694c9a979ae22c673a79bf2fa29fe6888f7243dcdd7dd38882af4ead720d6" => :catalina
    sha256 "2f502a8f1c11e5c01dd0141d83935cfd0e357dd75a352848564260c49da400aa" => :mojave
    sha256 "1e3aca16a694b761c0267c0dfdd9933d43cddd3ed0ea9d20fd4016222a7748f9" => :high_sierra
    sha256 "009c0a8a81d783393abc8ca6307631c50e50ba72dc09e3f2cda5f2e2d8aa617c" => :sierra
    sha256 "369c0df6b06b7ea116120e177a44a54760cc4d7132a1fb59a83ef52a99a6b5f4" => :el_capitan
    sha256 "3c91564548f9b7844de09de3d54b77b43e7855c17def6d3efac5866e357635f0" => :yosemite
  end

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
