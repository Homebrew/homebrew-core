class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://launchpad.net/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.50/glib-networking-2.50.0.tar.xz"
  sha256 "3f1a442f3c2a734946983532ce59ed49120319fdb10c938447c373d5e5286bee"

  bottle do
    sha256 "8d9f25c6ad40d0461faf185e2d82a6b54d2b8df4ef485ebdc6f00129f9302c71" => :sierra
    sha256 "c290a6c479db1ab06585a95f96201bb145e6c5679b8f06f0843a04b35fe596d7" => :el_capitan
    sha256 "6bae1d8857a518859b0ca169be84764521b6fe8df293a221a91450702c8a987f" => :yosemite
    sha256 "511c7ebff04d868ad0fc7518d286e7e675bca018db2fd34bb7c73e76ce31e748" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsettings-desktop-schemas"

  link_overwrite "lib/gio/modules"

  def install
    # Install files to `lib` instead of `HOMEBREW_PREFIX/lib`.
    inreplace "configure", "$($PKG_CONFIG --variable giomoduledir gio-2.0)", lib/"gio/modules"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-ca-certificates=#{etc}/openssl/cert.pem",
                          # Remove when p11-kit >= 0.20.7 builds on OSX
                          # see https://github.com/Homebrew/homebrew/issues/36323
                          # and https://bugs.freedesktop.org/show_bug.cgi?id=91602
                          "--without-pkcs11"
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
      int main (int argc, char *argv[])
      {
        if (g_tls_backend_supports_tls (g_tls_backend_get_default()))
          return 0;
        else
          return 1;
      }
    EOS

    # From `pkg-config --cflags --libs gio-2.0`
    flags = [
      "-D_REENTRANT",
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-I#{HOMEBREW_PREFIX}/opt/gettext/include",
      "-L#{HOMEBREW_PREFIX}/lib",
      "-L#{HOMEBREW_PREFIX}/opt/gettext/lib",
      "-lgio-2.0", "-lgobject-2.0", "-lglib-2.0", "-lintl"
    ]

    system ENV.cc, "gtls-test.c", "-o", "gtls-test", *flags
    system "./gtls-test"
  end
end
