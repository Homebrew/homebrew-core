class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "https://www.gethomebank.org/en/index.php"
  url "https://www.gethomebank.org/public/sources/homebank-5.10.4.tar.gz"
  sha256 "f8072131328e7c1d6ca336f809e265e483c6d6d21f3654bc520700d27deae2d8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.gethomebank.org/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "1cb5dffff7a9b706d9fc1a8314fb733ac7d1e9dba92b590acbf21cb7b0dc0b46"
    sha256 arm64_tahoe:       "2401e8227cb13f9de1dcf89b6bfd0eafa26b38d12d37bb8a29e10092b49f8c0f"
    sha256 arm64_sequoia:     "80a9c76f9e24b128cd09d0df0389487d25de98a69627db6b238c73e3c467d228"
    sha256 arm64_linux:       "00b09eedf572a3377473ed8a33721eb1526491d4eedf1385a5d493d5de259d75"
    sha256 x86_64_linux:      "22083dfe1482b212a832340f5b5c40a45d301848cde30c71c57680897085aa10"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    system "./configure", "--with-ofx", *std_configure_args
    system "make", "install"
  end

  test do
    # homebank is a GUI application
    system bin/"homebank", "--help"
  end
end
