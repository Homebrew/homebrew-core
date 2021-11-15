class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.5.1.tar.gz"
  sha256 "88beeb896b6a1138046f665c3495f85670a74a527e34743080d8976d3f1b73b7"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2ffc2bc0e39598db641205b5bc890d73b7732ddc7bf423c047e1ff98557911a3"
    sha256 cellar: :any,                 arm64_big_sur:  "517f8d4c5a645597e7a7766a1ba9e74d56ec6981471adb094b7e507d70b10d49"
    sha256 cellar: :any,                 monterey:       "3120bccc885a4f6162a9a8f96d242ccd42d742e91a2968dd17d8358bbbb0b913"
    sha256 cellar: :any,                 big_sur:        "50eac7eb295237c2962591c65d00359073d01c9df48bfb222da2c107185ef32e"
    sha256 cellar: :any,                 catalina:       "fb579482e70e738cca521cfc3a47d5369a5354f281c7889b93a2fa78e85de40a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c58d0b0830a267a73fb438d4fec4b1c9306d87f0522f83899749b062f28c0ae"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

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
