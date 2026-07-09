class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "https://www.gethomebank.org/en/index.php"
  url "https://www.gethomebank.org/public/sources/homebank-5.10.2.tar.gz"
  sha256 "f0beafe07ea22155c8f8e267798d6eb05d6e015d5660b96fb34fdeca5a6bc4c7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.gethomebank.org/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f8acf36dcc600a51c0a0577fcae6fff43cced30e6775c1a69ace49f6b23c116f"
    sha256 arm64_sequoia: "27ccfea4b001f6a2d3361ba1687fc4ff05775411dbc11b301254bd8091780f7e"
    sha256 arm64_sonoma:  "52aab13d2fd46ab8995fde3f4ca2226d33e5d503bb7ca62c2629bb39aff1a0bc"
    sha256 sonoma:        "75ce6beb4b7bf4ce40724af7789a2b29e16344b8f59d7148d4d788e83f7343c2"
    sha256 arm64_linux:   "1131d591e8646bec5eacf394ef409e294a519d44ccd2659a4550a016e6fdc098"
    sha256 x86_64_linux:  "48a3475d25060f8741d09f725417b78e99f2c1056f6da28d6f8eb2daa0991932"
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
