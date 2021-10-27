class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://wiki.gnome.org/Projects/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.6/json-glib-1.6.6.tar.xz"
  sha256 "96ec98be7a91f6dde33636720e3da2ff6ecbb90e76ccaa49497f31a6855a490e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "8d0477538b5e84536dd970d2dda48d46d89b5159996f41bf2c17b02ea7ee4075"
    sha256 arm64_big_sur:  "dbaac34029a64a5d23c4c3d58f579cca68a9b65fa2ba6d8e44cac55781acce32"
    sha256 monterey:       "e23445c25a457a3fd6b076a60a1ec4d2732e1f8a22ff73f4db2a06b36cc40430"
    sha256 big_sur:        "a3fb508a2f6f41c61d4b6a2392e9c1b724176325bfc75e8df298e77a04b07e12"
    sha256 catalina:       "b583d641d9a5f529d4f54e2b58a8ed081dfcb8047ae107919d1144ce18c9681c"
    sha256 mojave:         "4e6b678d4ec9dc003e261ca69be62178f49429425b29a84fee2fa47897fe0465"
    sha256 x86_64_linux:   "5def8d6b0014378f86ed161dcf1570e2ca5432c5616d34e7f96c84d6fd4ff97d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dintrospection=enabled", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <json-glib/json-glib.h>

      int main(int argc, char *argv[]) {
        JsonParser *parser = json_parser_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/json-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -ljson-glib-1.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
