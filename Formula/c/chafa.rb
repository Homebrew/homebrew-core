class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.18.2.tar.xz"
  sha256 "0b8d9ba9f347e8b6c0c71878217c9b0e478b4a42aa4babea0bf20840567239c2"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e54e1ad7b3ffca076aa84f9c2031fb9b6b2cb9e8d3b10cb4aa26c60584f3fa9"
    sha256 cellar: :any,                 arm64_sequoia: "e5e873b1ee62224e64475a25ecc7f4f45018e49a9d165fb4811dd84af8eb05b5"
    sha256 cellar: :any,                 arm64_sonoma:  "f033ead5057314428ad6caefe760c189fcdfdd0db1955db50a4a13b7065e6aeb"
    sha256 cellar: :any,                 sonoma:        "c9af1b713bca7cc95181e378ba3edf010e196e3044fd72596f857b002bdd46f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f79d52cd5d1c0bca9a7f856e2e85084b5a134985427a1f8e8d78d4f413bda18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d3b052da8221a35b0cd35c22618ad4bb21c474df36372c4d9597331bcc2a940"
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
