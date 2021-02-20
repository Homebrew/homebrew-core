class GnomeAutoar < Formula
  desc "GNOME library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.3/gnome-autoar-0.3.0.tar.xz"
  sha256 "f2c112c0120cca2bf5a82c5b0ac8cba90ce10d21fec78f50a3bc513fdd64586b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "c6e08f12eb6dfd6bc180807ac90df1442265256c2ebbb67a111fa09873d0d59b"
    sha256 big_sur:       "ed23a1cc6375962d89c85e43d72064197ff70d8ecaffe4d09560a154fe45603d"
    sha256 catalina:      "94f0f34bc7dc823d9b094ffc7d4bc59fb383f02a4f149564c3708bb06676a3ea"
    sha256 mojave:        "aface7d5ba3f2d50a2072d138c7dca23bbff86e9eb1c5ffeb6cdcc7cac7fc4ef"
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
