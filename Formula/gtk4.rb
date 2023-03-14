class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.10/gtk-4.10.1.tar.xz"
  sha256 "e8fcac04bc7715b9da667c911a5ee8f262e200d1d6a50adf23645ca8cfcd0311"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c772d0ef9832bbb1ed8c1c7ded39352306b1e9d6ddac5eb17e1f6eb609e1b386"
    sha256 arm64_monterey: "6444595f5500a2ea3322df5f29ac2f4e69e1246c2e0b2c5b256fad8f0310437e"
    sha256 arm64_big_sur:  "af47119b8d55923ba5757c7af3e901c6262a4bae3a3bb464d6641f1a3c28accd"
    sha256 ventura:        "b3e459992304c50a4baa934708183f10413506589cdf56738def7043d40ffbc5"
    sha256 monterey:       "f43c0e0fea067a6f6a52685213f228b33791607aef969cdb3e71213e27cd20e6"
    sha256 big_sur:        "2fd3e3ce3e2825a9ec37d8efbee8935da7776dab30959818e79bf1701af94d42"
    sha256 x86_64_linux:   "51f82e64a773f4872cde1854c0f2fa7cb9880206eea3b56629386e38cfab99e5"
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
