class GlibOpenssl < Formula
  desc "OpenSSL GIO module for glib"
  homepage "https://launchpad.net/glib-networking"
  url "https://download.gnome.org/sources/glib-openssl/2.50/glib-openssl-2.50.8.tar.xz"
  sha256 "869f08e4e9a719c1df411c2fb5554400f6b24a9db0cb94c4359db8dad18d185f"
  revision 3

  bottle do
    sha256 "d3e3d452515afbf8ab39555e7c9e4add50f28aa89252321bee6ca021c7cb88a9" => :catalina
    sha256 "10b207a9c340bc6710e1df7f47ef4a0dba5a941c0cdb3330255718cf1884276c" => :mojave
    sha256 "04107ac3e021e4dd11feb50a3ac4024f3c73dd2b805f171ccfc22c1d7e3a665e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    # Install files to `lib` instead of `HOMEBREW_PREFIX/lib`.
    inreplace "configure", "$($PKG_CONFIG --variable giomoduledir gio-2.0)", lib/"gio/modules"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-static",
                          "--prefix=#{prefix}",
                          "--with-ca-certificates=#{Formula["openssl@1.1"].pkgetc}/cert.pem"
    system "make", "install"

    # Delete the cache, will regenerate it in post_install
    rm lib/"gio/modules/giomodule.cache"
  end

  def post_install
    system Formula["glib"].opt_bin/"gio-querymodules", HOMEBREW_PREFIX/"lib/gio/modules"
  end

  test do
    (testpath/"gtls-test.c").write <<~EOS
      #include <gio/gio.h>
      #include <string.h>
      int main (int argc, char *argv[])
      {
        GType type = g_tls_backend_get_certificate_type(g_tls_backend_get_default());
        if (strcmp(g_type_name(type), "GTlsCertificateOpenssl") == 0)
          return 0;
        else
          return 1;
      }
    EOS

    # From `pkg-config --cflags --libs gio-2.0`
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -D_REENTRANT
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -lgio-2.0
      -lgobject-2.0
      -lglib-2.0
      -lintl
    ]
    system ENV.cc, "gtls-test.c", "-o", "gtls-test", *flags
    system "./gtls-test"
  end
end
