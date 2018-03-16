class Libgtop < Formula
  desc "Library for portably obtaining information about processes"
  homepage "https://library.gnome.org/devel/libgtop/stable/"
  url "https://download.gnome.org/sources/libgtop/2.38/libgtop-2.38.0.tar.xz"
  sha256 "4f6c0e62bb438abfd16b4559cd2eca0251de19e291c888cdc4dc88e5ffebb612"

  bottle do
    sha256 "93d65fe5d0e5727fa542adb6f21fbbdb0812d7cfe93345d693864bb017f90d35" => :high_sierra
    sha256 "351fcbb0c758d7435e58862c3ffeaef9c437e53dcf43a7ab4ca4dc260cb014e0" => :sierra
    sha256 "fc47a0ffb4dd010bf29bc8dd6e0d88a75a2ccb66b33e5a43869e20303e2e9fcb" => :el_capitan
  end

  # Some build deps were added for the patch below,
  # and can be removed on the next release:
  # autoconf, automake, gnome-common, gtk-doc, libtool
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnome-common" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"

  # Fixes the build on OS X by providing a stub implementation of a new feature
  # https://gitlab.gnome.org/GNOME/libgtop/issues/36
  patch do
    url "https://github.com/GNOME/libgtop/commit/42b049f338363f92c1e93b4549fc944098eae674.patch?full_index=1"
    sha256 "f05b31e0490f9f98c905a771c02071a554dac9965378d60137e50f1e50e84bed"
  end

  def install
    system "./autogen.sh", "--disable-debug", "--disable-dependency-tracking",
                           "--prefix=#{prefix}",
                           "--without-x"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
