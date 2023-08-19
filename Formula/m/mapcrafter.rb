class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36ff4b40514ff54c7796b7e71066027767ca3c11da6d16985ad46ecab54e42c9"
    sha256 cellar: :any,                 arm64_monterey: "eb153aadf3c2e8045cbe44e90c6d853a22c568550036d3bcca79fd6696a5b884"
    sha256 cellar: :any,                 arm64_big_sur:  "ded0b905addf1bb71549afed880edab9edb1abed2cb0a4c27956e8eaf42f1e50"
    sha256 cellar: :any,                 ventura:        "49ec055023f31d116deccd3fdf1f7b580f3f4d1809cd648b5a71539002e43cf6"
    sha256 cellar: :any,                 monterey:       "151c271cc060321f496cb589c64a090a1f41e4f1c4fff4058253f01e84847f68"
    sha256 cellar: :any,                 big_sur:        "f41228de2471a1a044d181bcb3afc03bde67369235f486bc2cbe926a9268fc2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "257afbb0520e3f954f24fc9103aa90b5a2325705dafd07e79bd19916d0c5dfe9"
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
