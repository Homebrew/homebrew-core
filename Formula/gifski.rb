class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.9.0.tar.gz"
  sha256 "b2a3455243187da9a3755da5e5c5c708d9bfdc69d0020db769f610aa6311ea2a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1d277ecc5ad79024e421ff18f6de3e82eabc55cba98fab834fbb113743ec3041"
    sha256 cellar: :any,                 arm64_monterey: "d105edaac1b6a070d46647aafead9278af768d58a3fc00e6b4af413c80543ed4"
    sha256 cellar: :any,                 arm64_big_sur:  "3c9c8962ac980fe76ff2ea3d64f0a394104bb8ce17f77f67855492211591b82f"
    sha256 cellar: :any,                 ventura:        "13ec00435a9e2b8167f839a5a224e3f08ef24cb9cfe1bf77599424b09155fc34"
    sha256 cellar: :any,                 monterey:       "c4d4a85939bded629264ab405188f1e1f0650d36793db8e093a4c455d8aca60f"
    sha256 cellar: :any,                 big_sur:        "30d39f04a94e0df00ed1784a01309d42517ba8b2326fefbc4b53743df9d2ee54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bf2c8116a1a9bc5f370affd0edabfbe1e688f5e876100274a042bfb3c7b32e2"
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
