class GnomeAutoar < Formula
  desc "GNOME library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.2/gnome-autoar-0.2.3.tar.xz"
  sha256 "5de9db0db028cd6cab7c2fec46ba90965474ecf9cd68cfd681a6488cf1fb240a"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "df3a4bb92f24256d2fdd61c1d8bf0e99df2e5d3ff5caa8e4b9a5fab86335a264" => :mojave
    sha256 "0278e7cbdbdb3115090a0a27cb7328ededbd8b3952d71b9568060db5c1b60198" => :high_sierra
    sha256 "af8b60ddb40832e09b435e12a5e2d047ef36dcb7ac1cb0ae4c3a0577c19dcb7d" => :sierra
    sha256 "3b15fdd123e16bddd846335e4e1d473770fb337007ef88ffa33fc6de90052e7b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libarchive"

  def install
    ENV.delete "SDKROOT"
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
