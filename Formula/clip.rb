class Clip < Formula
  desc "Create high-quality charts from the command-line"
  homepage "https://github.com/asmuth/clip"
  url "https://github.com/asmuth/clip/archive/v0.7.tar.gz"
  sha256 "f38f455cf3e9201614ac71d8a871e4ff94a6e4cf461fd5bf81bdf457ba2e6b3e"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "acf22810f4d0f153a53b2c35bc995c74757e3241d8d43f312a7cd5898dd1cf35"
    sha256 cellar: :any,                 arm64_big_sur:  "220094b17e96838d519b0cd2f9cf76f7ad9e281eda6e905d5089305e2f0397e0"
    sha256 cellar: :any,                 monterey:       "3df0179ee07c6eefd3b47f41729efaa8d75000c818896f28f7a86195470439b8"
    sha256 cellar: :any,                 big_sur:        "2d983a2abf0507d882b39affed117a6d57db4e5b1867aa9ab47f3f8f20b4a1b6"
    sha256 cellar: :any,                 catalina:       "7df786779866b3f1800f2adca1646085bddaa8ef98129ec27ec868968fa867cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9078f87299b67452fe186206012954ef0b54b77c14b0fb8972c7238ccd1be73c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  fails_with gcc: "5" # for C++17

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system "#{bin}/clip", "--export", "chart.svg",
           "test/examples/charts_basic_areachart.clp"
    assert_predicate testpath/"chart.svg", :exist?
  end
end
