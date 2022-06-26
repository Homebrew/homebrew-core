class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/1.5.2.tar.gz"
  sha256 "ad804ec228100bd5a329a9dcd88d987e70b93c9fd714bb2b3dce6cf016b8c8e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "449a6738088d6e491de9fab0df1c23d7ab2bdb317a1e13840d0f825f8a83797a"
    sha256 cellar: :any, arm64_big_sur:  "e6c6c8e7221e6311ffa712d1bd2331fe3fa727f0b7e51759b2723ae53eeada4d"
    sha256 cellar: :any, monterey:       "092f965ca4c91baf8a32586b6152e0d53fa22f6d47ff1bf627d54b24832677dc"
    sha256 cellar: :any, big_sur:        "7dc30133bf7d780a3377672a6bb4d224f57c138b1aa063bda8a6a0cf88276210"
    sha256 cellar: :any, catalina:       "e7470605bb8000f9fe5ed84eea0f839127fded8ce3a0949b0a93bd5ce18e6f49"
    sha256 cellar: :any, mojave:         "2aef3e5730b1109de45d3748d0e17d78b2181c8eff7b417200c8b2e187681385"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "samples" # for a simple library linking test
  end

  test do
    system ENV.cc, pkgshare/"samples/sgemm.c", "-I#{include}", "-L#{lib}",
                   "-lclblast", "-framework", "OpenCL"
  end
end
