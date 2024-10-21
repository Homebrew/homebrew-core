class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.8.5.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.8.5.tar.gz"
  sha256 "4eb4451e57840395468c2d6a3fe4d016ada0ba7d47ca7f1cec0418c0a1339e97"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/h/homebank/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "94bf4b49f731be4f47f29034b43db67dc2db8e9fcbadb0b55ac6644ded05cbc6"
    sha256 arm64_sonoma:  "cb68025bcc4d10dc10710bd614b393b520aa2635d72a89c0064c87500acfbd4f"
    sha256 arm64_ventura: "6397871dffdac218ae42417a09da94949e3cb5fcd275fd37763418764b835d1a"
    sha256 sonoma:        "e2bb671af014440ce5abd396c9a2aa7779486e281b6406c73226e0291e8962ee"
    sha256 ventura:       "43f9a4732805e49ca347104054191c26fdb66b723725d76a78021efb3246c707"
    sha256 x86_64_linux:  "cb439c613da62c89dfc5d8c80f8d7f2057d0834f6016d772ab2f693388cf20b0"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"
  depends_on "pango"

  uses_from_macos "perl"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", "--with-ofx", *std_configure_args.reject { |s| s["--disable-debug"] }
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    # homebank is a GUI application
    system bin/"homebank", "--help"
  end
end
