class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.5.1/qalculate-gtk-5.5.1.tar.gz"
  sha256 "dcf33e89ec2539c3e0bf9c5aee18b44680f6630b1e02cf23e2e9add6578450c7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:  "6c39d6caced24fc7ba6961fe555175467fda6fe25ee2101c3dfd899cb9c591c3"
    sha256 arm64_ventura: "9a1c8e13ef2dc561a1f136468738ba34a668fa68593ed8ad69f0262b5de30529"
    sha256 sonoma:        "074c2652d0fda500db768d049a99bdf5d37397315e03a0097bcd0ebc1307e59d"
    sha256 ventura:       "3215ef935dbcc30f7ba4285116b25bdcf8e428c3978eff2bd78f7c6ffc09e762"
    sha256 x86_64_linux:  "df4d889c9daa8452784656dc945bcbfa0b41f1f25a71d7ac1f6dbc7696f04d24"
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
