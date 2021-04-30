class GnomeAutoar < Formula
  desc "GNOME library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.3/gnome-autoar-0.3.2.tar.xz"
  sha256 "a48c4d5ce9a9ed05ba8bc8fdeb9af2d1a7bd8091c2911d6c37223c4f488f7c72"
  license "LGPL-2.1-or-later"

  # gnome-autoar doesn't seem to follow the typical GNOME version format where
  # even-numbered minor versions are stable, so we override the default regex
  # from the `Gnome` strategy.
  livecheck do
    url :stable
    regex(/gnome-autoar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "bce66e3b2f1bf7e89cf91260a60a2ee50761fad6ac4313433a04b29e7fc84334"
    sha256 big_sur:       "0b356bb42d02fd282554b943216524156835d9d294693ec4228eec830d742074"
    sha256 catalina:      "637dabc9403bb4a841a4ad1a37913c8f5408919536962d0933863c73b36265a1"
    sha256 mojave:        "dd4d6a2cac634191e73cd0423e444c89694838569d65f062fa9d21373ca782ca"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libarchive"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gnome-autoar/gnome-autoar.h>

      int main(int argc, char *argv[]) {
        GType type = autoar_extractor_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libarchive = Formula["libarchive"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gnome-autoar-0
      -I#{libarchive.opt_include}
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libarchive.opt_lib}
      -L#{lib}
      -larchive
      -lgio-2.0
      -lglib-2.0
      -lgnome-autoar-0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
