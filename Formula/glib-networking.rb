class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://launchpad.net/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.56/glib-networking-2.56.0.tar.xz"
  sha256 "47fd10bcae2e5039dc5f685e3ea384f48e64a6bee26d755718f534a978477c93"

  bottle do
    sha256 "656488bcc70e2347d705dfc32ef38952088c8d7a2279766e139c19485c5d87aa" => :high_sierra
    sha256 "7afca55538868826fd196e670de31a16740efb44490f1633c57d49ac1ac3c7c3" => :sierra
    sha256 "4ef4b72f13a2f5c83e63c7594b2a643ca93f5f141b90554a70bc7f8532af5070" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsettings-desktop-schemas"

  link_overwrite "lib/gio/modules"

  # see https://bugzilla.gnome.org/show_bug.cgi?id=794292
  # merged in upstream, remove when update is released
  patch :DATA

  def install
    # Install files to `lib` instead of `HOMEBREW_PREFIX/lib`.
    inreplace "meson.build", "gio_dep.get_pkgconfig_variable('giomoduledir')", "'#{lib}/gio/modules'"

    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = ""
    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      # Remove when p11-kit >= 0.20.7 builds on OSX
                      # see https://github.com/Homebrew/homebrew/issues/36323
                      # and https://bugs.freedesktop.org/show_bug.cgi?id=91602
                      "-Dpkcs11_support=false",
                      "-Dlibproxy_support=false",
                      "-Dca_certificates_path=#{etc}/openssl/cert.pem",
                      ".."
      system "ninja"
      system "ninja", "install"
    end

    # rename .dylib to .so, which is what glib expects
    # see https://github.com/mesonbuild/meson/issues/3053
    Dir.glob(lib/"gio/modules/*.dylib").each do |f|
      mv f, "#{File.dirname(f)}/#{File.basename(f, ".dylib")}.so"
    end
  end

  def post_install
    system Formula["glib"].opt_bin/"gio-querymodules", HOMEBREW_PREFIX/"lib/gio/modules"
  end

  test do
    (testpath/"gtls-test.c").write <<~EOS
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
      "-lgio-2.0", "-lgobject-2.0", "-lglib-2.0"
    ]

    system ENV.cc, "gtls-test.c", "-o", "gtls-test", *flags
    system "./gtls-test"
  end
end

__END__
diff --git a/meson.build b/meson.build
index f923e53..a295d2d 100644
--- a/meson.build
+++ b/meson.build
@@ -112,9 +112,9 @@ if enable_libproxy_support or enable_gnome_proxy_support
   subdir('proxy/tests')
 endif

-if enable_pkcs11_support
-  tls_inc = include_directories('tls')
+tls_inc = include_directories('tls')

+if enable_pkcs11_support
   subdir('tls/pkcs11')
 endif

diff --git a/tls/tests/meson.build b/tls/tests/meson.build
index 7e1ae13..fbefb15 100644
--- a/tls/tests/meson.build
+++ b/tls/tests/meson.build
@@ -1,4 +1,4 @@
-incs = [top_inc]
+incs = [top_inc, tls_inc]

 deps = [
   gio_dep,
@@ -25,8 +25,6 @@ test_programs = [
 ]

 if enable_pkcs11_support
-  incs += tls_inc
-
   pkcs11_deps = deps + [
     libgiopkcs11_dep,
     pkcs11_dep

