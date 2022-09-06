class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "787a4156146e10c6a47853010fe3a6209ee29edd99288739053959e3fe942bfc"
    sha256 cellar: :any,                 arm64_big_sur:  "c16d450b6f17c7940672a2a029f30db1436703783643d5086767eac97185d711"
    sha256 cellar: :any,                 monterey:       "4f10840bc41b9609ae938b2c17a19f11dbdf2905c8e96aad173a2f66dae1c9c9"
    sha256 cellar: :any,                 big_sur:        "27d406bba19b092d6713d17b5d11583c6022c672fda0f4231cb3be73ef8ccb1a"
    sha256 cellar: :any,                 catalina:       "3126138292de05f6fe29ca6f951696efafb01e44ad7ace316a1e9df6db5cdbab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "182394f0857e830efd8705bfbdd52bb5afd9a86ca1f33fc98d8ed6b5710b394f"
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
