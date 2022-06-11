class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.7.0.tar.gz"
  sha256 "f9d66778d763f2391fa626261d24815799f1dfe61ce9ee0cc5637692172db29d"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff9a703f6f1ccad514c4eed9b1f2fb54e02f245b6e765b551e1bad28fbecf870"
    sha256 cellar: :any,                 arm64_big_sur:  "7f8fb7a008f173ed43074a3c2c7aa5c48f809e92ffd88096926625ce7b8fab66"
    sha256 cellar: :any,                 monterey:       "704e3011b96b4cb7865c3fe77adaa27d849acb3ee0cf638e08817e97d34aca0a"
    sha256 cellar: :any,                 big_sur:        "b5ddc35b04a75f1e553a97c90e09a2671146ead4511e69324b4fc82c6ede8d5d"
    sha256 cellar: :any,                 catalina:       "eb5d6832ad98307405113d443144dc7632aeddb77fdb788ef5bf6c977f5bffdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3fd4fb52b0eb0131eb866949f7dbe3f9dd63cd23d0d04cbb4e46a424447b056"
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
