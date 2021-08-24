class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://wiki.gnome.org/Projects/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.6/json-glib-1.6.6.tar.xz"
  sha256 "96ec98be7a91f6dde33636720e3da2ff6ecbb90e76ccaa49497f31a6855a490e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "9144e462862235426bf8d7901f719f5db5c69a01658dc6c690eac3a89b5c9a79"
    sha256 big_sur:       "520330aa60afa6b10ff37b481efeccb6edc773d0f33dbde68c2f88cc90eedf68"
    sha256 catalina:      "f3116ac48b3acdecc384e110e84be26c211b475cb7e1007ceaaedad4611054d9"
    sha256 mojave:        "91cb0342846214588c95f9c338e67d181ec77d237dbd93009e3dfdd831feec85"
    sha256 x86_64_linux:  "aef61281d66f276b85663dd82fe297ea8b4d7af55ad5880d3f67a3aa3df92dd4"
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
