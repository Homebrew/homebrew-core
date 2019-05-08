class Libgtop < Formula
  desc "Library for portably obtaining information about processes"
  homepage "https://library.gnome.org/devel/libgtop/stable/"
  url "https://download.gnome.org/sources/libgtop/2.40/libgtop-2.40.0.tar.xz"
  sha256 "78f3274c0c79c434c03655c1b35edf7b95ec0421430897fb1345a98a265ed2d4"

  bottle do
    sha256 "b89c3928a514ee28b9c61b84dca3ba1e30c5a5a9139393584c586f4a588565ab" => :mojave
    sha256 "fdb3efa795c853b46c36ebae7f973ea12300164006b65472f0074c92297ab2e7" => :high_sierra
    sha256 "49189c9ebcfb5592992e40fb65e4caeace8bd5ac1e1860bf7cdfe24a742fd5aa" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
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
