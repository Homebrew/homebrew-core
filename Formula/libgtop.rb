class Libgtop < Formula
  desc "Library for portably obtaining information about processes"
  homepage "https://library.gnome.org/devel/libgtop/stable/"
  url "https://download.gnome.org/sources/libgtop/2.38/libgtop-2.38.0.tar.xz"
  sha256 "4f6c0e62bb438abfd16b4559cd2eca0251de19e291c888cdc4dc88e5ffebb612"
  revision 1

  bottle do
    sha256 "3a648a7dc340187b64384a2fb04738cd9da41773f6f8237e242d3354adcf5eca" => :mojave
    sha256 "ebe7cd41964c94cc59a4734eac1a04a9b64038c69234f6f3fb131266450d57f7" => :high_sierra
    sha256 "903f395ddb70fd42c184323584437e156836b8dea5e69f6e9bb54f4fd39b0987" => :sierra
    sha256 "fe1a65675f609a65a3aa8938080472df2f84159f163de616a50683de3ab6a3f3" => :el_capitan
  end

  # Some build deps were added for the patch below,
  # and can be removed on the next release:
  # autoconf, automake, gnome-common, gtk-doc, libtool
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnome-common" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  # Fixes the build on OS X by providing a stub implementation of a new feature
  # https://gitlab.gnome.org/GNOME/libgtop/issues/36
  patch do
    url "https://github.com/GNOME/libgtop/commit/42b049f338363f92c1e93b4549fc944098eae674.diff?full_index=1"
    sha256 "1a208c5a246f51b16413ef5ca370afc6aba3ceebae0c616da1dcf1d8b9c0e2f1"
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
