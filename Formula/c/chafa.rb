class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.16.1.tar.xz"
  sha256 "4a25debb71530baf0a748b15cfee6b8da6b513f696d9484987eaf410ecce1129"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b47791ad994a4308ec6953961070a7b87d375c02a267d51126672a4a98cae288"
    sha256 cellar: :any,                 arm64_sonoma:  "ee5a09d5ede1dcbc5f73f8e6f0b00d88598c3ce7e46936fc2a3c121b46150245"
    sha256 cellar: :any,                 arm64_ventura: "a47d806bacd65b10cd53aef2177dc9f8f634db185e75cd12c5f0e9e5c08afb21"
    sha256 cellar: :any,                 sonoma:        "26fd74c17eb1ec652698842902c0417feb5da973e62d81d1ddcb8c12bf57b34e"
    sha256 cellar: :any,                 ventura:       "eea6878b22a219dc0d5694c89f4b3be1475935b6f49a4f76c6094cfa1f8a792b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3285c74e450f5e7bcb52ccd45039f95fb1a06c5b1b492f970e323a1476fcbe01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a4be7443e2d8cfc43c5b78758944850ce359a48ab988144b2bd8724341ab0e2"
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
