class Clip < Formula
  desc "Create high-quality charts from the command-line"
  homepage "https://clip-lang.org/"
  url "https://github.com/asmuth/clip/archive/v0.7.tar.gz"
  sha256 "f38f455cf3e9201614ac71d8a871e4ff94a6e4cf461fd5bf81bdf457ba2e6b3e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ea142f44aa36d839d13be1ffa7cb28e7823a02756e3df5c73f454723685de8e6"
    sha256 cellar: :any, big_sur:       "1f54104c2d751b61f7a206956a8fdf9ac636bcd88fe0e39bf397d2a38fa98308"
    sha256 cellar: :any, catalina:      "421298a9039ad6645a2ff605f1e3e3ccf5e0ee345e71195e41e67e4ed1f7cfdf"
    sha256 cellar: :any, mojave:        "3f4983068feacbb39d6238e33c0516ac4bdff11c19b8e12321d06c47e39c9107"
    sha256 cellar: :any, high_sierra:   "e62a216d1b86f6775f07c5484099e905943ee283d0ad51aef812be4089624171"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

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
