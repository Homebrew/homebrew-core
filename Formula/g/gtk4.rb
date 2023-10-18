class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.12/gtk-4.12.3.tar.xz"
  sha256 "148ce262f6c86487455fb1d9793c3f58bc3e1da477a29617fadb0420f5870a89"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f44f31d9a220357beabd3db55ab802185b6afcc5b94ba3a16e13dfe84b09a744"
    sha256 arm64_ventura:  "73a887bca2a27d369027c8a01ad0d46ae531055a51c7da7a54079ec3564c0e7e"
    sha256 arm64_monterey: "8459e35842015867877cc64e04166b62216049e1bf94c9f57cc32e8db137457e"
    sha256 sonoma:         "8155a6fcea9753412a08b4f72bd3f5b516a937acce9405e2c0959308636212b1"
    sha256 ventura:        "97c1021d1312e42055cb31ba0da8514208c2a0ffb265fe71896f0f43d4da53e4"
    sha256 monterey:       "9f73d0fd6b5eb332ea16d91f48a37b0d56faafb56a0bbfc0e68928bbc5d2f4bc"
    sha256 x86_64_linux:   "cc422a47a87958e4f5932d12c3170734572ed4548b7a498a5dd9ec8ae0783cbd"
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
