class GnomeAutoar < Formula
  desc "GNOME library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.2/gnome-autoar-0.2.3.tar.xz"
  sha256 "5de9db0db028cd6cab7c2fec46ba90965474ecf9cd68cfd681a6488cf1fb240a"
  revision 2

  bottle do
    cellar :any
    sha256 "d4eb4086335d897d68ee5a0d09947f500e18a93161429473d44d6cb81b962bf1" => :mojave
    sha256 "007d55df1aea731560ecef0221251db7285e6b4fdd5b266680e6e5e55a6c2074" => :high_sierra
    sha256 "0bf8f1ccb106a998b22d7f0da8636ba355a9f984d81b4282db04b021db2c9ce9" => :sierra
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
