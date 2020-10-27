class Clip < Formula
  desc "Create high-quality charts from the command-line"
  homepage "https://clip-lang.org/"
  url "https://github.com/asmuth/clip/archive/v0.7.tar.gz"
  sha256 "f38f455cf3e9201614ac71d8a871e4ff94a6e4cf461fd5bf81bdf457ba2e6b3e"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "421298a9039ad6645a2ff605f1e3e3ccf5e0ee345e71195e41e67e4ed1f7cfdf" => :catalina
    sha256 "3f4983068feacbb39d6238e33c0516ac4bdff11c19b8e12321d06c47e39c9107" => :mojave
    sha256 "e62a216d1b86f6775f07c5484099e905943ee283d0ad51aef812be4089624171" => :high_sierra
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
