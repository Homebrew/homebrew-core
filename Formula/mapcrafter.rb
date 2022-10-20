class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "44e58878dcca0fafcad78133a2dc333e285f71716de830a264147ce2c42155cc"
    sha256 cellar: :any,                 arm64_big_sur:  "3a6bc0db21092639082f548fdf8a3072750f0273d5efe7968fc7b3c71183623e"
    sha256 cellar: :any,                 monterey:       "58e38265d1e6152ed0ca7d35cb992f878a4cfd9a09b6f72806959a3b51cb8678"
    sha256 cellar: :any,                 big_sur:        "8107c6f213679b2cb451607364773541449b764963707e29084e2562f2acd33c"
    sha256 cellar: :any,                 catalina:       "e1532320d92c4e5797aab789f4d26d11e871f8eb4fdfb3c5dd5b1f5995f3ab4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e32000df4087a54bff7cb1b46289d89ef6a6d27b83d43d60397f29ca0a3ed70"
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
