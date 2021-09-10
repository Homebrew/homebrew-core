class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.5.1.tar.gz"
  sha256 "88beeb896b6a1138046f665c3495f85670a74a527e34743080d8976d3f1b73b7"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f476e0a8786b81d909f6074d710c86e0097d909a802835010ca9a2e385e37f62"
    sha256 cellar: :any,                 big_sur:       "e75740a344bac5b985ff6b2ca63603fee1e10bdf00a2afa59e749862cab64f14"
    sha256 cellar: :any,                 catalina:      "338e8fa823d6b5c31edf455d82ab21786b58051a9d7e5a3c96ff9aff47aee428"
    sha256 cellar: :any,                 mojave:        "a8a74c3a065e7f6258d645e409c4db5405116f2ef9f0541fdfeec5f5850d0ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb794542ce69009441cc0096706c5777192913eef8ef9c285cb4014b771013ae"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build

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
