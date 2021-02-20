class Libgdata < Formula
  desc "GLib-based library for accessing online service APIs"
  homepage "https://wiki.gnome.org/Projects/libgdata"
  url "https://download.gnome.org/sources/libgdata/0.18/libgdata-0.18.0.tar.xz"
  sha256 "f0c20112fa5372b62c01256f268aef5131a161dfc23868f393ecf7b8b3752580"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "413a354df3ae8ea57c10b586e51dae29e58a62b1ab31f7f39a3604d368f31f9f"
    sha256 cellar: :any, big_sur:       "ef65e8ecd410c9f9123922def6c7ccff264f235965e292fc3eab6bf6be93349f"
    sha256 cellar: :any, catalina:      "1e7c809fca23a4ce3f61177749f6fd814bbe2f465caa8dada1f6b6c6f8be2c50"
    sha256 cellar: :any, mojave:        "d09ac23f65b3bc9a63c22cb45d7a7742a70fc11af0fcedcee39f2c643f3cd4e1"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "liboauth"
  depends_on "libsoup"

  def install
    mkdir "build" do
      system "meson", *std_meson_args,
        "-Dintrospection=true",
        "-Doauth1=enabled",
        "-Dalways_build_tests=false",
        "-Dvapi=true",
        "-Dgtk=enabled",
        "-Dgoa=disabled",
        "-Dgnome=disabled",
        ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdata/gdata.h>

      int main(int argc, char *argv[]) {
        GType type = gdata_comment_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    liboauth = Formula["liboauth"]
    libsoup = Formula["libsoup"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libgdata
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{liboauth.opt_include}
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{MacOS.sdk_path}/usr/include/libxml2
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{libsoup.opt_lib}
      -L#{lib}
      -lgdata
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
      -lsoup-2.4
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
