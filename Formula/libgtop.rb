class Libgtop < Formula
  desc "Library for portably obtaining information about processes"
  homepage "https://library.gnome.org/devel/libgtop/stable/"
  url "https://download.gnome.org/sources/libgtop/2.36/libgtop-2.36.0.tar.xz"
  sha256 "13bfe34c150b2b00b03df4732e8c7ccfae09ab15897ee4f4ebf0d16b0f3ba12b"

  bottle do
    sha256 "905b69d0eba1e911a3a28283bb09e8730d0e6b41828743023b2683e40c6c09ee" => :sierra
    sha256 "cfc23b37015f59335471d7bef1dff4ce57f80c1b7ca26e880c29b69ccffbd5b4" => :el_capitan
    sha256 "24939165028218ae307ff6de5adec798978db9a80719881d2b20e418bc3328d0" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <glibtop/sysinfo.h>

      int main(int argc, char *argv[]) {
        const glibtop_sysinfo *info = glibtop_get_sysinfo();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libgtop-2.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgtop-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
