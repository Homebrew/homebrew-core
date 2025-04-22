class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.14.5.tar.xz"
  sha256 "7b5b384d5fb76a641d00af0626ed2115fb255ea371d9bef11f8500286a7b09e5"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ea6049848cb7fd6d0f094877c2a451f3c04abc24fc32c1e6cf9fe4b9dc1381e7"
    sha256 cellar: :any,                 arm64_sonoma:  "718bad199de13187fdff368cb98f7163162bf76d57c0a6ba1cb2c151ec98a4df"
    sha256 cellar: :any,                 arm64_ventura: "5af1c494a1b7daceb2e8d10cc895fe6e59fa3f10fbd493150cdc24cee1ee1150"
    sha256 cellar: :any,                 sonoma:        "e83b7e5f17bcb3b0698797f5b50f952a5ca09cf9f0489bb4842ae21d0d066b12"
    sha256 cellar: :any,                 ventura:       "b36b0aa9e21626083a0e6e86d33e3a96f935f7c47640292f202823b3c8fc402b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a18bdb4424e04b4319bd6f7b99153dcb7c231b778ae21d64484cd88408deae75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc49d8207b352f3adf9b570363b0a40986addfc14deedab6181c55594e6d18a"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "webp"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* AVIF.* JPEG.* JXL.* SVG.* TIFF.* WebP/, output)
  end
end
