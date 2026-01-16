class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.18.0.tar.xz"
  sha256 "cd7475441ab8042e89dad706124999dd0aa3dc64653cdc20d49338549b9fcadb"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d598c0fe9033cf7e9e939efe492283a30f636a3fb12b08ec170ba74d2581574e"
    sha256 cellar: :any,                 arm64_sequoia: "da2bbff403c721e8ea861213a2b71143989b12307bd33a6343f6885bfc97e651"
    sha256 cellar: :any,                 arm64_sonoma:  "145c02c480bbd3bf68f6d812cc85fc3d3c9edc8c9802607821fcc78fba7f22de"
    sha256 cellar: :any,                 sonoma:        "fa7578814208f8b4b7c8c3803ad0e5984aef4b60a1525d67470b4e9a13f39a2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7286a827cf973c440b1ab5d1aa977aed918516b74f0c0e830c3106f17267e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a6b476d3c0086b2d3030379d496f74cdde6167366d0452963302afda78e8d1"
  end

  head do
    url "https://github.com/hpjansson/chafa.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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
    with_env(NOCONFIGURE: "1") { system "./autogen.sh" } if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    man1.install "docs/chafa.1" if build.stable?
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* AVIF.* JPEG.* JXL.* SVG.* TIFF.* WebP/, output)
  end
end
