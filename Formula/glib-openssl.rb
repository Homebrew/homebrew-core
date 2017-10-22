class GlibOpenssl < Formula
  desc "OpenSSL GIO module for glib"
  homepage "https://launchpad.net/glib-networking"
  url "https://download.gnome.org/sources/glib-openssl/2.50/glib-openssl-2.50.4.tar.xz"
  sha256 "eda914e29d9d72f03185aba92c33ec3949862c05b73b8eb04d1e1b6217b756c0"

  bottle do
    sha256 "b99c6da78317e0d5e8e2e7718d725ba0320823fe7f5fcf803f7549067a55d993" => :high_sierra
    sha256 "80d38bf5724fdc10cca163f44f46a82f23d92a855c399bad12b8f9574c4d131a" => :sierra
    sha256 "f47bde181be1548c0961937739b32a70ec85e984bba0b276bf6b69b9536585b9" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl"

  def install
    # Install files to `lib` instead of `HOMEBREW_PREFIX/lib`.
    inreplace "configure", "$($PKG_CONFIG --variable giomoduledir gio-2.0)", lib/"gio/modules"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-static",
                          "--prefix=#{prefix}",
                          "--with-ca-certificates=#{etc}/openssl/cert.pem"
    system "make", "install"

    # Delete the cache, will regenerate it in post_install
    rm lib/"gio/modules/giomodule.cache"
  end

  def post_install
    system Formula["glib"].opt_bin/"gio-querymodules", HOMEBREW_PREFIX/"lib/gio/modules"
  end

  test do
    (testpath/"gtls-test.c").write <<-EOS.undent
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
