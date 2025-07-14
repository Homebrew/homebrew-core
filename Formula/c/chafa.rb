class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.16.2.tar.xz"
  sha256 "657898dd9a89b45130a44c1efe1fc03e2c7bd00c2f543ed7111613cb9e7861df"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "411a2e13b828399d7ddef65cd14e70843de6ca70c441c7b673234c5c8a2905c4"
    sha256 cellar: :any,                 arm64_sonoma:  "ec3913e5394e2d4e1fd9d9b14fe4e1cfdb9d286c540a964eda184046617f8e2d"
    sha256 cellar: :any,                 arm64_ventura: "f118d8e83c58f87634dcde8ea5559455b3ac97717e6c1904028928e887f9594f"
    sha256 cellar: :any,                 sonoma:        "c61f2dc4aec088da2f8ee58b0d531f1dcd6236ac254859aafdcb860addc7dccf"
    sha256 cellar: :any,                 ventura:       "cde2384f2b98ca94c8cc4e84fb611782b74cd99444b32640815785ee83fa89bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "984e11e7dc20fbe41bfda805599364127542362b12937563e66b4e0a7d1eb373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6137876e39395029f5a2f8ac4980a08acd60b4a29ccf92a6ea3dcc1564c4461b"
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
