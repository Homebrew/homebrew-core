class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.7.2.tar.gz"
  sha256 "a686cba9b9874d06ff138249119b796960d30fa06d036ce51df93d8dde6b829f"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "ad1d6084e9f06f1a8d8601f988a1e6fb7057174df5841e4a9157fac0a65a1a60"
    sha256 cellar: :any,                 arm64_big_sur:  "d17cd7c01944d1868928debaea3b440fefb1f77d04f882f49e6c60f40bd9464b"
    sha256 cellar: :any,                 monterey:       "a8ae5fd607d327693c41c953f3bd795bec2cdd2a6685aab118517b9cf6725100"
    sha256 cellar: :any,                 big_sur:        "0052439c326c966371734039503ad38cbb0e81b560cff8967019d036be4a155e"
    sha256 cellar: :any,                 catalina:       "b9eee9279bf404f00e01c6930aed817d8aab53b4314139d397d935ee064a4d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a02b16b00857089e0950b4ca09c6e77f1ec4b1eb4b6819f791e9d073f04b2c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@4"

  uses_from_macos "llvm" => :build

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
