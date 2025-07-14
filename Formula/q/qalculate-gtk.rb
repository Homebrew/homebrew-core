class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.6.0/qalculate-gtk-5.6.0.tar.gz"
  sha256 "3dabd3b1ed981222b7fe7d2c14d47926715b8ae13098b0a4bdaa9dce96eee36d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:  "58f7dd41979bfa92d9786078ded460e464f4ef114402bdbf3d88cd7bf61526ef"
    sha256 arm64_ventura: "f3555784ba0f2aa5209d12331cf08a305b44fe063c09ad6b08810a44cc450886"
    sha256 sonoma:        "7e6e9984b07084ff042b743ee93d4b87bf3cefafaba20a1afa586167eb544575"
    sha256 ventura:       "d1dc50584c3e9d1baca9b5ec16b08f97a2c2551a47debbdd3e6d37a171131c25"
    sha256 x86_64_linux:  "c844f4e4ffa683ae2c26a10f65d9f18dcc9cfa7fc5fa2e1ecec867d335c8e9d6"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libqalculate"
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
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalculate-gtk", "-v"
  end
end
