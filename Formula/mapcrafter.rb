class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  revision 2

  bottle do
    cellar :any
    sha256 "dda2be9eff21f02193d886a797a4997d0017d5c6c66173f28c2f8da46bd11f20" => :sierra
    sha256 "8f8e91a44d4fcb2424fa0f16036683f2b5c80cdfd5918e668b0f61560ad30a50" => :el_capitan
    sha256 "fe3f7f1633b833731a96933470ddec7ac8a928a11c6b6f6f38befed5ff503c59" => :yosemite
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}"
    args << "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/libjpeg.dylib"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_match(/Mapcrafter/,
      shell_output("#{bin}/mapcrafter --version"))
  end
end
