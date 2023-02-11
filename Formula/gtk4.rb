class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.8/gtk-4.8.3.tar.xz"
  sha256 "b362f968d085b4d3d9340d4d38c706377ded9d5374e694a2b6b7e6292e3cba74"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e07869f5cc0267aa9253905be9671f3f96e216d4a173adb3bf64caafde7b3552"
    sha256 arm64_monterey: "f12c9abafdb4234089cfbd21182fb74a6d906ee11c04ed5200a8e45d2bc03d49"
    sha256 arm64_big_sur:  "04de533c329cc4e30831e286297ba8dc5a3d15756d97954ae58d3f446c226f0d"
    sha256 ventura:        "c1a584a3b91b19144634fa6e8fa63b50888eb03fb083abede6c2c6161a864c68"
    sha256 monterey:       "2342a7c9ea83768a71948add66de3cb0c8eb50051efd8d9dbac45629b03878d4"
    sha256 big_sur:        "e2464c1f9bc9388c23d41b93c79c862c3e0b0a573923abe767cc993d1d0ebb58"
    sha256 x86_64_linux:   "48a0960071ef39e2c6f4bb28b1cb74df8f819aca7c1273b2bf5435e203a3a2d9"
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

    pkg_config_cmd = Formula["pkg-config"].opt_bin/"pkg-config --cflags --libs gtk4"
    pkg_config_flags = shell_output(pkg_config_cmd).chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk4.pc").strip
  end
end
