class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.18.1.tar.xz"
  sha256 "e75a9772444247a70178cdd238b522d35c613dfb6f3a3bf516457958109e9910"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8481084fe39e9971a49c4e1aa094c161230de635d53afb45e07e25a21b654cb5"
    sha256 cellar: :any,                 arm64_sequoia: "0dcd125a55d77500044cdeff708777e60229d8120c85fed9186bb2194a51a8bf"
    sha256 cellar: :any,                 arm64_sonoma:  "41113fa3f691c936a3805e7cc9cd00b860d50dbbbe2ad7bb65074425d592254b"
    sha256 cellar: :any,                 sonoma:        "c4cc89aed4c4637d304044c4f44bc8a761f348dedad467a955d22b98bf6628a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04eeb0c26b507b7b9c6b71c46f1aa92f03ee255cf52a78eef07926c64b867b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356f1d9486e4e1a759490d85492e7eda81262ac3e36299bc1d8724c98ac98b73"
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
