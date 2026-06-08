class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/refs/tags/1.7.0.tar.gz"
  sha256 "cac83330a6110214f2b7efc8e46062536f40ba96122f3b2a074a51497d8ca9e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6419de6a1707a9f92213abcdbb0c4e4488d5ff3418bcbe963baa4d5e72216f89"
    sha256 cellar: :any,                 arm64_sequoia: "da027f3b522bee07118cc60e30053e1f00225d999662ffff5c87b4142b424c09"
    sha256 cellar: :any,                 arm64_sonoma:  "3f7078481cccaf1a9460c703a71988f942292c45133fcff6b14209a4819c7674"
    sha256 cellar: :any,                 sonoma:        "9a3c4d995812d34bb57bd5711a844a57da1fe8a2e10b350bd2b9ac835766443d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5350ca100c8aa37c957be25c450fbde3404feb82732b6aab364058279ce7120b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d5aad3b2483aafef5d30926805f7add78e9438687d52aa7972e89ad28aecd2a"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "samples" # for a simple library linking test
  end

  test do
    opencl_library = OS.mac? ? ["-framework", "OpenCL"] : ["-lOpenCL"]
    system ENV.cc, pkgshare/"samples/sgemm.c", "-I#{include}", "-L#{lib}",
                   "-lclblast", *opencl_library
  end
end
