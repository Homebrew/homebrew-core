class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "https://www.gethomebank.org/en/index.php"
  url "https://www.gethomebank.org/public/sources/homebank-5.10.3.tar.gz"
  sha256 "574de504cceafdb6138ffa2e03be567ad66b8a2ceaef3434e07ca695e82dd9e3"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.gethomebank.org/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "21c4d3808031ecb579f8160accb34090ec72200422fde880459c42ca70e9fc81"
    sha256 arm64_tahoe:       "073aa8b75ec27f5f14e7c49320294a80254844fdb178e0cdb20b9795a258dfcd"
    sha256 arm64_sequoia:     "3a378498d970be0493dd692784f6712e630535e2adf3bee7704603a68784c2ce"
    sha256 arm64_linux:       "6a264cb71a143ae6bed1344a0284d24e67f2fa51bcaf86df1ccde354bff6e4f7"
    sha256 x86_64_linux:      "9e6f57bfdece02901fdd3dcba126b3dbf56256d6c8339c7ad8c0f148a40cd09d"
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
