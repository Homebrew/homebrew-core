class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://gitlab.gnome.org/GNOME/goffice"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.59.tar.xz"
  sha256 "b08f7173325594b71fbbea476a30b5b3120c3dadff5c0a26d140e4e524916622"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_sequoia: "f9d3ab0788e1062443680621dc3c842ac1feb8a43f64f833e4444af8d6a2338e"
    sha256 arm64_sonoma:  "3b5acae5f179e394cb1fbe1d8bfa72be79fd277d26d0345681f85d54b30b177a"
    sha256 arm64_ventura: "80dff5d4cec61b9eb1b00c336f695b9dc4330354dfe5e941d0e2f65ba36c8ef1"
    sha256 sonoma:        "6d2a1f621b9e1b566175ae8009ce596af26eb1627b131930629ae12932ac3e95"
    sha256 ventura:       "28ae6bfa295c143a57dc073e361d44adde10c38a729b99d3b31c463f6484bf7e"
    sha256 arm64_linux:   "0924fab05e1c0c4e99ec721f5032037d7ffc30d5fe18fb009a76e1ef61c1d168"
    sha256 x86_64_linux:  "997be7bf90f3a411067e99056514c271a28ea09b98a01b58d3ab9a07fef85f4f"
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
