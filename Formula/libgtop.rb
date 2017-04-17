class Libgtop < Formula
  desc "Library for portably obtaining information about processes"
  homepage "https://library.gnome.org/devel/libgtop/stable/"
  url "https://download.gnome.org/sources/libgtop/2.36/libgtop-2.36.0.tar.xz"
  sha256 "13bfe34c150b2b00b03df4732e8c7ccfae09ab15897ee4f4ebf0d16b0f3ba12b"

  bottle do
    sha256 "c7197f1afe98c3ee5e5b6ab1e7c7ed629c08b1f37d17312ab01c06fda637c718" => :sierra
    sha256 "1aa4cdb2dfdf236eb3b9802d88cade9bb30c9358af5ddf6710e313a0b19b0e29" => :el_capitan
    sha256 "68166fd2c7020a59d0a6f4bdc6820c5f461fa813b30e6de14c9728149e619d0d" => :yosemite
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
