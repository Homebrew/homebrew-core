class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.8.2/qalculate-gtk-5.8.2.tar.gz"
  sha256 "20a3d4c4c63f53236cdaa79234e8d51e4deb5b647aff32bc310b920261ce68a3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "6ab05efe372106b95bc3e8e27ad0708d92b5d603e746aa13fd22a981a1812449"
    sha256 arm64_sequoia: "b0e528c99ffc2b442ed559072fe198052f774389c1722aee40e9e024ae5c040e"
    sha256 arm64_sonoma:  "faf25d4cbeeeff005f37734a86144466d6ca3b8fd264aebbaf8b322f8fa26ff6"
    sha256 sonoma:        "0cd1827043296bf236e3ca4b756cf21b04a721ee68bca166620665aa58637ff9"
    sha256 arm64_linux:   "6e916f5b2600e06df676deeb8b6d966a4cab698c31c2338c6b81866cb81fdff5"
    sha256 x86_64_linux:  "7dc09e0d8e5650452db436252aa1c28effe3becf8d0903e7b9da48154ee3a4c2"
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
