class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://gitlab.gnome.org/GNOME/goffice"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.59.tar.xz"
  sha256 "b08f7173325594b71fbbea476a30b5b3120c3dadff5c0a26d140e4e524916622"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 1

  bottle do
    sha256 arm64_tahoe:   "f7cca500e0ab41b0313cf04fb31bd410127184f95acec882200f08e43ecc5de5"
    sha256 arm64_sequoia: "060649b1ed0e0e0f78c61e894901e8df0125ebd0afd19bcd441db904bbc824d2"
    sha256 arm64_sonoma:  "be9fc30dd0e795078b78121c0eef803e88ebdb041533321e024511baaaf51a4b"
    sha256 sonoma:        "60689135455b992b96e31a543b9304dc3ae653eafc0d1265ad6d2f7743416294"
    sha256 arm64_linux:   "7d712286334fbfbf894290bbbb8096518b6e8cca2ea59f065651127940d8d269"
    sha256 x86_64_linux:  "13762ea06a61d7602ad017e04510d0ca981aa38d82f84959518ba55570020c4d"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/goffice.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "librsvg"
  depends_on "pango"

  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <goffice/goffice.h>
      int main() {
        libgoffice_init();
        libgoffice_shutdown();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgoffice-#{version.major_minor}").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
