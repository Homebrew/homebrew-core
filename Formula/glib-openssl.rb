class GlibOpenssl < Formula
  desc "OpenSSL GIO module for glib"
  homepage "https://launchpad.net/glib-networking"
  url "https://download.gnome.org/sources/glib-openssl/2.50/glib-openssl-2.50.6.tar.xz"
  sha256 "1703a1da93911cf7f386e5fd9f82b803a150448e257db749166c0c3a1b5d3880"

  bottle do
    sha256 "f7152e43e3d84f770c55918ffb70dc0905600d8272f21b6d22922feb6c57eb11" => :high_sierra
    sha256 "5bc4f9b2ab920bb23b63d0eccc4eff7dc3658679c05c9d90fe48835841c29d2d" => :sierra
    sha256 "10caa120aee05bd9b9a078e21b547dc360dc9931c9712b1293d2ef1a29f5e64d" => :el_capitan
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
