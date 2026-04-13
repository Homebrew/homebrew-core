class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://gitlab.gnome.org/GNOME/goffice"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.60.tar.xz"
  sha256 "01154338cbffac172fc53338ebb9d527c821ffc21985a2ccfa84923ee6b761c5"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_tahoe:   "bac138cd3f363ebd627fc6de468106df6fe5e5c55b64b4846e0fe66267077714"
    sha256 arm64_sequoia: "29a23473fe4bc6e6c758ac2ea46637e1f54b1f438ec60948960ac843046caeab"
    sha256 arm64_sonoma:  "9e5c6d2f0128c5f23c3b924840ccd91248cbe8ca1e90b3d5ce5b7f79a3099e2f"
    sha256 sonoma:        "80f44565bc28f967973d4288c75b8d7752be8c3fc65a849dfcd425b11bc5e903"
    sha256 arm64_linux:   "9f1421d8076912d40ba9aaefaa93dca043041500352231f354eef946299ad742"
    sha256 x86_64_linux:  "4e6f8ab8d12f8d7b7b0cbdadafd7bd5f0404c63d7d4e67d4bd4fd7f16055c672"
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
