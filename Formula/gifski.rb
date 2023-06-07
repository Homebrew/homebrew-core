class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.10.3.tar.gz"
  sha256 "5ba367f9d9f144d1e489c2393930b0eddfae7a8fcc732be22aabd66bb8b2fc62"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a9d427548c008bbca1ed5e8d457331409dec9e1206014e6216df75b539979d82"
    sha256 cellar: :any,                 arm64_monterey: "83b14077d2e6516c3d7bb874137340a30245ce9431a808eb12e71fd4a2bbf30c"
    sha256 cellar: :any,                 arm64_big_sur:  "173e8755c447eb64cb67843c8a79eea6aa94f704461f0802f09c480f851977d3"
    sha256 cellar: :any,                 ventura:        "a115a46c8804014991a4a53010769bb9c1edb5cdb1699fec4b4fcfa25d594dbf"
    sha256 cellar: :any,                 monterey:       "d30257efa193545064fd598abe840475baeb632deb2ee98056a003b379cb5306"
    sha256 cellar: :any,                 big_sur:        "ef76fad69dce0f91e6c9dbfae0a7756ec15ce3a4f8a5c6f41d47755d09b3ec72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73c107b9ea6f21de0f3816cca1145bbc6875d048e0dd41ba2ced4584d4da94dc"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@4" # FFmpeg 5 issue: https://github.com/ImageOptim/gifski/issues/242

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
