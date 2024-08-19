class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.2.0/qalculate-gtk-5.2.0.tar.gz"
  sha256 "1a917fe5d5ca03e21a97308bac31f013d5459edd090ba20717eaf56259270dbd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "645b694a80851f8b67fd45baf9b24cdcb4420c07b2807309eebf0ec14d778c07"
    sha256 arm64_ventura:  "bf666fb4d35cf60fd4bbbee812bfb6561b7b1a4269cb8f91af5ee57d6bc6d581"
    sha256 arm64_monterey: "e7b0e16b885d55ff247f2c03cb08df66874edeed05306fdae968b6d4c01f9d3c"
    sha256 sonoma:         "e77f877ba1e0ff2251b984add05a071ea1e027a4ffdaee6c8dc215f76b1491ef"
    sha256 ventura:        "f5978b9950674544b136c42cde24f4cc1fade12378e63064e8263a50961bb93d"
    sha256 monterey:       "5bc3ca14a97963521c4ec0a0b55aa6f3ac09843dff6379cb50511299e3f54e65"
    sha256 x86_64_linux:   "d8367367da463d8abb883fe8d6feae317dc755a304f6291e88038f2cf3208bb7"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

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

    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system bin/"qalculate-gtk", "-v"
  end
end
