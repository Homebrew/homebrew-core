class GeocodeGlib < Formula
  desc "GNOME library for gecoding and reverse geocoding"
  homepage "https://developer.gnome.org/geocode-glib"
  url "https://download.gnome.org/sources/geocode-glib/3.20/geocode-glib-3.20.1.tar.xz"
  sha256 "669fc832cabf8cc2f0fc4194a8fa464cdb9c03ebf9aca5353d7cf935ba8637a2"

  bottle do
    sha256 "de5b33dd569563477d4750bc16adb3d92dc163dd7fcf61d2814192916ab9018f" => :sierra
    sha256 "3ebd3cff23719235de5b5599c3eb4e332a87b7e768353ac0baee64e22dfc130b" => :el_capitan
    sha256 "a19ac1603fb2d3c379501275dc209bdfe19f032b7460a6e6a260cd43f8b5810e" => :yosemite
    sha256 "16c2add2adeab490024f7c7d7620be8be7e6545073dde7979389df50f8d75c1b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "gobject-introspection"

  def install
    # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "icons/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # delete icon cache file -> create it post_install
    rm share/"icons/gnome/icon-theme.cache"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/gnome"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <geocode-glib/geocode-glib.h>

      int main(int argc, char *argv[]) {
        GeocodeLocation *loc = geocode_location_new(1.0, 1.0, 1.0);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/geocode-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgeocode-glib
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
