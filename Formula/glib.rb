class Glib < Formula
  desc "Core application library for C"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.62/glib-2.62.0.tar.xz"
  sha256 "6c257205a0a343b662c9961a58bb4ba1f1e31c82f5c6b909ec741194abc3da10"

  bottle do
    sha256 "de1bacf18d547a429b058ce9fd3e98befe04158ac757d5e6de46a2589ab8b74f" => :mojave
    sha256 "527dc608bd9204c39a54c2558d522ef392138950c1676a61100aef1bdc18170a" => :high_sierra
    sha256 "e9aa21523883246876506367c7d40fd2badcaaa70296fe56695859ad0fd5b3ab" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libffi"
  depends_on "pcre"
  depends_on "python"
  uses_from_macos "util-linux" # for libmount.so

  patch :DATA

  # https://bugzilla.gnome.org/show_bug.cgi?id=673135 Resolved as wontfix,
  # but needed to fix an assumption about the location of the d-bus machine
  # id file.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6164294a7/glib/hardcoded-paths.diff"
    sha256 "a57fec9e85758896ff5ec1ad483050651b59b7b77e0217459ea650704b7d422b"
  end

  def install
    inreplace %w[gio/gdbusprivate.c gio/xdgmime/xdgmime.c glib/gutils.c],
      "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    args = %W[
      -Diconv=auto
      -Dgio_module_dir=#{HOMEBREW_PREFIX}/lib/gio/modules
      -Dbsymbolic_functions=false
      -Ddtrace=false
    ]

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    # ensure giomoduledir contains prefix, as this pkgconfig variable will be
    # used by glib-networking and glib-openssl to determine where to install
    # their modules
    inreplace lib/"pkgconfig/gio-2.0.pc",
              "giomoduledir=#{HOMEBREW_PREFIX}/lib/gio/modules",
              "giomoduledir=${libdir}/gio/modules"

    # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
    # have a pkgconfig file, so we add gettext lib and include paths here.
    gettext = Formula["gettext"].opt_prefix
    inreplace lib+"pkgconfig/glib-2.0.pc" do |s|
      s.gsub! "Libs: -lintl -L${libdir} -lglib-2.0",
              "Libs: -L${libdir} -lglib-2.0 -L#{gettext}/lib -lintl"
      s.gsub! "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include",
              "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{gettext}/include"
    end
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/gio/modules").mkpath
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <glib.h>

      int main(void)
      {
          gchar *result_1, *result_2;
          char *str = "string";

          result_1 = g_convert(str, strlen(str), "ASCII", "UTF-8", NULL, NULL, NULL);
          result_2 = g_convert(result_1, strlen(result_1), "UTF-8", "ASCII", NULL, NULL, NULL);

          return (strcmp(str, result_2) == 0) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}/glib-2.0",
                   "-I#{lib}/glib-2.0/include", "-L#{lib}", "-lglib-2.0"
    system "./test"
  end
end

__END__
diff --git a/gmodule/meson.build b/gmodule/meson.build
index d38ad2d..5fce96d 100644
--- a/gmodule/meson.build
+++ b/gmodule/meson.build
@@ -13,12 +13,12 @@ if host_system == 'windows'
 # dlopen() filepath must be of the form /path/libname.a(libname.so)
 elif host_system == 'aix'
   g_module_impl = 'G_MODULE_IMPL_AR'
+elif have_dlopen_dlsym
+  g_module_impl = 'G_MODULE_IMPL_DL'
 # NSLinkModule (dyld) in system libraries (Darwin)
 elif cc.has_function('NSLinkModule')
   g_module_impl = 'G_MODULE_IMPL_DYLD'
   g_module_need_uscore = 1
-elif have_dlopen_dlsym
-  g_module_impl = 'G_MODULE_IMPL_DL'
 endif

 # additional checks for G_MODULE_IMPL_DL
