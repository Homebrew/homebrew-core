class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f786c84b53b86f31c87c30480983c30723ff815d99df4ae3429e49537ac1e4db"
    sha256 cellar: :any,                 arm64_big_sur:  "edbdf533f4676b9c443d7706a27677d1f3cfea3e0a0ded1170fbcffbb055e270"
    sha256 cellar: :any,                 monterey:       "891b8a077a364221f4e2ddbfd6398b511c550ce56f8c79517c082cbb2b7d2b5a"
    sha256 cellar: :any,                 big_sur:        "74994382e57db8e66f2bd68174bee30b9a8fffd4074cbe1fe3140428290b38ff"
    sha256 cellar: :any,                 catalina:       "15cdf3e3cb8b21ea23408a4d74466fa0be14ad75a1c5553851863cc1cbe68d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2419f5064a2581f3389486cf6c48c428899d00e5e2d102911f529dc973ecad56"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}"
    args << "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib/shared_library("libjpeg")}"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_match(/Mapcrafter/,
      shell_output("#{bin}/mapcrafter --version"))
  end
end
