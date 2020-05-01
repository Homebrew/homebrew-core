class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.7.1.tar.xz"
  sha256 "bb26106ad4a9f8523f81b332d2aedb717cdcb0500b3f68ba7c6ff945c4d627e9"

  bottle do
    sha256 "e067499ce7ea69830ea63755751426063e6e1f4b74b09ec9bb35c7ddf825bf25" => :catalina
    sha256 "a138545c508f69286a5e9b86fc945f95b79eb625de270dc19a853f3d5ab4638c" => :mojave
    sha256 "594fbfda840d8bd4169da48d5f6cd5076329ec9b0a21d0ebafe96a0732a00cca" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "libxml2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Denable-gtk-doc=false", ".."
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <osinfo/osinfo.h>

      int main(int argc, char *argv[]) {
        OsinfoPlatformList *list = osinfo_platformlist_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libosinfo-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -losinfo-1.0
      -lglib-2.0
      -lgobject-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
