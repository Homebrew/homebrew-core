class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.12/gtk-4.12.2.tar.xz"
  sha256 "2f4f4d4f92e09f216d386cfdadd54d33d97f23a4555d67b97decfa6f815b6b81"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2b1d6374b816cb21a87666e3285831ea5e36d0a21a21808a89f7ae04531756e1"
    sha256 arm64_ventura:  "5b923de901b87ebb056c200ed7df25766e6ee625d09faef7b68be8bea3f7703f"
    sha256 arm64_monterey: "c73f29eb63f04d6b07600ae411684c8a72f532671d4ee4496960f9fb623a4c08"
    sha256 arm64_big_sur:  "a4135b668f0b89cf2c47a8c5f0fd7d31465d33e02d34ef5cb473cc6c6ac92016"
    sha256 sonoma:         "cd18ca402f8c9af1fceba88c6dcdcd8cc28f72ccc4ac409cf161360006c66ea5"
    sha256 ventura:        "09bbdbed01415ac0e54f888c60a87b158ac57d0327150647c5ea2f10ef504997"
    sha256 monterey:       "9c310b295e70a4d9d8b9626df5010c3fcf03415fed3c6f4469cd46d36a0cc3ab"
    sha256 big_sur:        "e217c1ea95d44d800734eb93009d4974535bd2dbd8aa1520b538b6875ff00d3f"
    sha256 x86_64_linux:   "1743cb8842b8d74c276b191a7aed3ee13d1813467292ec24c52108ed93a3054d"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "docutils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "sassc" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "hicolor-icon-theme"
  depends_on "jpeg-turbo"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cups"

  on_linux do
    depends_on "libxcursor"
    depends_on "libxkbcommon"
  end

  # patch macOS build
  # upstream PR ref, https://gitlab.gnome.org/GNOME/gtk/-/merge_requests/6208
  patch do
    url "https://gitlab.gnome.org/GNOME/gtk/-/commit/aa888c0b3f775776fe3b71028396b7a8c6adb1d6.diff"
    sha256 "07604078655c73b5db8b5fcdf2288677f0d19a791f336293d7f1c561819488e1"
  end

  def install
    args = %w[
      -Dgtk_doc=false
      -Dman-pages=true
      -Dintrospection=enabled
      -Dbuild-examples=false
      -Dbuild-tests=false
      -Dmedia-gstreamer=disabled
    ]

    if OS.mac?
      args << "-Dx11-backend=false"
      args << "-Dmacos-backend=true"
      args << "-Dprint-cups=disabled" if MacOS.version <= :mojave
    end

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable asserts and cast checks explicitly
    ENV.append "CPPFLAGS", "-DG_DISABLE_ASSERT -DG_DISABLE_CAST_CHECKS"

    system "meson", *std_meson_args, "build", *args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["glib"].opt_bin}/gio-querymodules", "#{HOMEBREW_PREFIX}/lib/gtk-4.0/4.0.0/printbackends"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["jpeg-turbo"].opt_lib/"pkgconfig"
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtk4").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk4.pc").strip
  end
end
