class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.8.3.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.8.3.tar.gz"
  sha256 "e4083d52301dc53e51e9c615e954fb92d6951ea7749334282c2a5f4b9ab9c4c2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/h/homebank/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "b9f9017af9b13173b952a07e6538d3cbb8fc4ba2b2ed98cc2a98a9ea139be313"
    sha256 arm64_sonoma:   "e961cfe48ebf93c3e5c5e2deaa6fe761305c193e3c8b7707dbc620b6510942c5"
    sha256 arm64_ventura:  "126a1b4ca0f09b41aed111d9c89c99b963949e737b3208f66034c29cd1c06e75"
    sha256 arm64_monterey: "b2e8f7420cec8ff10c1a62ab8c74204ca525cae582489dce406a882cdc579ff0"
    sha256 sonoma:         "ea5bf6af665aeb808b6524d55fb39c8405cc5c6278b2fdd57bd6f0d744c362f4"
    sha256 ventura:        "c4ec13b9d8189eab84778738670fe04b95b7c1d950da05ab99d65ac9670723c8"
    sha256 monterey:       "cb5f99a78ce0db4fa87907bd4bcc819fbb6b383ebd6b7a9a6ca9130151966973"
    sha256 x86_64_linux:   "53c819aae13bd17d02d26d64ddc15792169ed08d50ce9b9d4e2e668dc83c0ffb"
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
