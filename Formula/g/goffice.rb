class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://gitlab.gnome.org/GNOME/goffice"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.61.tar.xz"
  sha256 "558597fd9ca59b93ff562750218d1e7ea8ec3c8d0ed6a5cc096aa715ef909a15"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_tahoe:   "522418201d09ea524f368f5ab087ab7bb37760d62b4aa2780e042942ef0df461"
    sha256 arm64_sequoia: "bb6b50141024dd9e959ca8e72155346419631de5704f4f428255b6af77224c6b"
    sha256 arm64_sonoma:  "61c51e1998edeae4f15f3dc5302c87b400c1ce0614d45e22aec245e833e00617"
    sha256 sonoma:        "fef69f79921e6530b9f083ff8e70a8976aeb10b0e4de6250f0bd195b7bf71edc"
    sha256 arm64_linux:   "5294caf9332c6befcfbec1049c30a00cbe5068733fb41522d7de2d4d27034fb6"
    sha256 x86_64_linux:  "e911e3bdf48cfb46e6dc8fcc61e10f5112d9dca1e809b8f7b997c527db731db0"
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
