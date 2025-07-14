class Gxml < Formula
  desc "GObject-based XML DOM API"
  homepage "https://wiki.gnome.org/GXml"
  url "https://gitlab.gnome.org/GNOME/gxml/-/archive/0.20.4/gxml-0.20.4.tar.bz2"
  sha256 "d8d8b16ff701d0c5ff04b337b246880ec4523abfe897a1f77acdf7d73fb14b84"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia:  "47216df062f881bebea1796d72ce28358e3eeb746dbf9215e80ae4476daa3902"
    sha256 arm64_sonoma:   "8f97268cf4c3e02ebb80664ad7130ed9e8a73651c8ee4a4edff6a0c49f109518"
    sha256 arm64_ventura:  "e6e950ee7e48514e6ba3b1f81037e99799886d05adf2fdf7a31d3939bf9b7196"
    sha256 arm64_monterey: "6fe172d27e676eb132acbef9b7a82d7e42658b1998babea50783504c2c4fa22c"
    sha256 sonoma:         "09e480a1b3fc86510efff4ec18fb6f2566d2f29a1c847289329db6625c4f3c25"
    sha256 ventura:        "bee9013ba03bee81e7224dcf0a4788daa943b53143033534b10f761d6c210630"
    sha256 monterey:       "19b816073438f3440875bfc354c81d5ac877576df616aa633a63c6951887fcd4"
    sha256 arm64_linux:    "138f902ae62c44ff26d94030f742d6d8bb7e0a2067337b15b4440562823acd9d"
    sha256 x86_64_linux:   "2655af742b291d5b01f09956dd4d7f812cf0351b4285a0a2e04bec744bfdc4bc"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "libgee"
  depends_on "libxml2"

  on_macos do
    depends_on "gettext"
  end

  # fix version comparison in gxml.pc.in, upstream pr ref, https://gitlab.gnome.org/GNOME/gxml/-/merge_requests/28
  patch do
    url "https://gitlab.gnome.org/GNOME/gxml/-/commit/6551103abd5143e51814ec1dce9b36bb9a46e09f.diff"
    sha256 "b87f585ab782b2ff4f024c45c9a90791c2023e3703756f2eb799591e7978e640"
  end

  def install
    system "meson", "setup", "build", "-Dintrospection=true", "-Ddocs=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gxml/gxml.h>

      int main(int argc, char *argv[]) {
        GType type = gxml_document_get_type();
        return 0;
      }
    C
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libxml2"].opt_lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs libxml-2.0 gxml-0.20").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
