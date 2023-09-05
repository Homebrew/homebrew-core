class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.12/gtk-4.12.1.tar.xz"
  sha256 "b8b61d6cf94fac64bf3a0bfc7af137c9dd2f8360033fdeb0cfe9612b77a99a72"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "43398ed6c38b4be07cf6b803f6e955b280e184ff3dcafbf1f054616e70ed3aa2"
    sha256 arm64_monterey: "51ef88e47f1a80f5f07f18ab12ad29f330fe3553abb9870e98171de1179e024f"
    sha256 arm64_big_sur:  "fa1bd23fecf73e09222c859581edcf902fbdc685cf7729a47827e3b84ae37e1c"
    sha256 ventura:        "9e76c4c18086a19bc83eb84f6b0eb38e11b7e70367bad93241cc84bf505285fd"
    sha256 monterey:       "3f2b2eaa50df962c940738a29d4e3713791ea6790e0725a1112b9b2ab42e93b0"
    sha256 big_sur:        "c144d21457505b8952d3b69e3d103a26e453b66b360668842316e21f3bae9596"
    sha256 x86_64_linux:   "7f782301229eeed595a3f50866b52ab1735998ed2c9b865df69099cc6f8d747b"
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
