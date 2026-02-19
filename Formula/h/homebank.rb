class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "https://www.gethomebank.org/en/index.php"
  url "https://www.gethomebank.org/public/sources/homebank-5.9.7.tar.gz"
  sha256 "2b8fdf512429a30ed7a457cf5af476756c0cfddc9fce7600dab95c7f03be26e4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.gethomebank.org/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3988f0b361d633eef069fbed7cde09c3b4ebd067187b9d11169ba1202b7ed5a7"
    sha256 arm64_sequoia: "da4e8fe1e597fdb149d5b7650b349dd7ec4176250ba69a406a75931654eefd0a"
    sha256 arm64_sonoma:  "fe2624c7b3006d5df116145b519a951d5015aee8108d3dbff1d5d8e6931c4209"
    sha256 sonoma:        "3b512e6ee0a6aa2a6004e064467561412aac122e88ae6e4ba95b9ff3cd0b226d"
    sha256 arm64_linux:   "93ef66a1d299281342aee3a472b1720985a171920a0a659517dc0b4514dc4af3"
    sha256 x86_64_linux:  "331f89447df7924ae0da3c5354d9106193b94a6faf0dd74060e87114103abd46"
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

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
