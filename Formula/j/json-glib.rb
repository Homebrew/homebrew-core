class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://wiki.gnome.org/Projects/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.10/json-glib-1.10.8.tar.xz"
  sha256 "55c5c141a564245b8f8fbe7698663c87a45a7333c2a2c56f06f811ab73b212dd"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "795e22cfc4a12fef555dfba6a3222af6cb6d30631cf69f176d1964169c14ba73"
    sha256 arm64_sequoia: "d0269d6d4933ad3c35fac9503d54facf36ea662a25b255c0d0fdf005bbfa2d25"
    sha256 arm64_sonoma:  "816c99b88faf50042ff7637cf58b674454c01ce1ea53178fb065c765b5f88930"
    sha256 sonoma:        "ae6a5d8e3370868b8bef9efd5601cd7849798cf9c182825d22d55d89f83a6399"
    sha256 arm64_linux:   "ee6d0e4f76dad15b66411637c444dddf8c262decee036e92a9af731c9bf537d8"
    sha256 x86_64_linux:  "f0337f01c95836d4b64a4df3547862711e1d12575ea127d00ef934cb196d41f7"
  end

  depends_on "docutils" => :build # for rst2man
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", "-Dintrospection=enabled", "-Dman=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <json-glib/json-glib.h>

      int main(int argc, char *argv[]) {
        JsonParser *parser = json_parser_new();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs json-glib-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
