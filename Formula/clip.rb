class Clip < Formula
  desc "Create high-quality charts from the command-line"
  homepage "https://clip-lang.org/"
  url "https://github.com/asmuth/clip/archive/v0.7.tar.gz"
  sha256 "f38f455cf3e9201614ac71d8a871e4ff94a6e4cf461fd5bf81bdf457ba2e6b3e"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "02d8da157f889f384abb2900d10ead88cc6bfaba984165e78a92f6fbce100f6e"
    sha256 cellar: :any,                 arm64_big_sur:  "20bb528940048dacd9f0eb67b3a1fe849e9e54d1c7e9a7c58da1fc9814beb1c8"
    sha256 cellar: :any,                 monterey:       "14853fce6b1e8ccd447df646d60b9277a23e72279dd74c40677b823451801995"
    sha256 cellar: :any,                 big_sur:        "cb33d312ff97b10b5761ceb105e3a5d63ab11c48db072c199108167cecf47854"
    sha256 cellar: :any,                 catalina:       "c6e0fc40838d76e9632e21e1a781603a1a75d584a3206300fe0a9f7272d9b702"
    sha256 cellar: :any,                 mojave:         "72f17c87e0c824cea89ba5fa383cf22d013751997a916a408eaa8408544292fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adbd6fc3d72a07a847e887fa050e91598e3045fa9d9dc251cec0953a6f6626d5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

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
