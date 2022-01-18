class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.6.4.tar.gz"
  sha256 "1bcc1bdbfdb206f44de75662ee5a8a8c61d336c04cb62457e02c9fa8456f3928"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e05fd57ae2a3248640a61aaf0670e046406c96692739cb12be5c9e698cfa45de"
    sha256 cellar: :any,                 arm64_big_sur:  "f19ed9829e3fbaf67ca7e59d9de7ced445a94e44e9599aef0e15cb8a8e4c6c02"
    sha256 cellar: :any,                 monterey:       "2d3539370bb451d9c39f2140b29e4c00d79d3b1e419cfddb8fd9ad297b279e78"
    sha256 cellar: :any,                 big_sur:        "8c22668a1a4d45c9a8ec3250cfa2982a080b200be7f3425bead9d7869288eb4d"
    sha256 cellar: :any,                 catalina:       "00dd6dd63acde50f8b8cfe3336d4f418d50fd554b47432eab042d04d86459604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4ceacab71cb4083409ef52f8487636600a0588f533751da2b451ae25ae1085"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@4"

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "gcc"
  end

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
