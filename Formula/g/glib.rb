class Glib < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Core application library for C"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.80/glib-2.80.0.tar.xz"
  sha256 "8228a92f92a412160b139ae68b6345bd28f24434a7b5af150ebe21ff587a561d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "501d6eb669b7bcffceb11c1261562a8533e954eef22c60142e6e524853c5f678"
    sha256 arm64_ventura:  "4e9c002ffb17843ff2f12e9ee048d155b4fd37a7af958bb0b71af451b42d7244"
    sha256 arm64_monterey: "389a862f6aa03faa91cd106c4315a66384207ff518db5552cfbca5b069950427"
    sha256 sonoma:         "fd936e04ae00e0528838ef9c1f4d98b9ccf43c974e4217cf135e47e524d27a7d"
    sha256 ventura:        "168dfba4d0446a472f517edd8c54e6b5f79abf831160c03455649b7fb0ef219f"
    sha256 monterey:       "1200202d25114587c55e7571146e7e2ed02ba4762462873ed518f0ab1ddee6f1"
    sha256 x86_64_linux:   "a0e5979697f119e4ab312e620de1ed6e3c175a93c8a95477edd16c10402e1c87"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre2"
  depends_on "python@3.12"

  uses_from_macos "libffi", since: :catalina

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "dbus"
    depends_on "util-linux"
  end

  # These used to live in the now defunct `glib-utils`.
  link_overwrite "bin/gdbus-codegen", "bin/glib-genmarshal", "bin/glib-mkenums", "bin/gtester-report"
  link_overwrite "share/glib-2.0/codegen", "share/glib-2.0/gdb"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  # replace several hardcoded paths with homebrew counterparts
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/43467fd8dfc0e8954892ecc08fab131242dca025/glib/hardcoded-paths.diff"
    sha256 "d81c9e8296ec5b53b4ead6917f174b06026eeb0c671dfffc4965b2271fb6a82c"
  end

  def install
    inreplace %w[gio/xdgmime/xdgmime.c glib/gutils.c], "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX
    # Avoid the sandbox violation when an empty directory is created outside of the formula prefix.
    inreplace "gio/meson.build", "install_emptydir(glib_giomodulesdir)", ""

    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    # and https://gitlab.gnome.org/GNOME/glib/-/issues/653
    args = %W[
      --default-library=both
      --localstatedir=#{var}
      -Dgio_module_dir=#{HOMEBREW_PREFIX}/lib/gio/modules
      -Dbsymbolic_functions=false
      -Ddtrace=false
      -Druntime_dir=#{var}/run
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # ensure giomoduledir contains prefix, as this pkgconfig variable will be
    # used by glib-networking and glib-openssl to determine where to install
    # their modules
    inreplace lib/"pkgconfig/gio-2.0.pc",
              "giomoduledir=#{HOMEBREW_PREFIX}/lib/gio/modules",
              "giomoduledir=${libdir}/gio/modules"

    if OS.mac?
      # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
      # have a pkgconfig file, so we add gettext lib and include paths here.
      gettext = Formula["gettext"].opt_prefix
      inreplace lib/"pkgconfig/glib-2.0.pc" do |s|
        s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
                "Libs: -L${libdir} -lglib-2.0 -L#{gettext}/lib -lintl"
        s.gsub! "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include",
                "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{gettext}/include"
      end

      if MacOS.version < :catalina
        # `pkg-config --print-requires-private gobject-2.0` includes libffi,
        # but that package is keg-only so it needs to look for the pkgconfig file
        # in libffi's opt path.
        libffi = Formula["libffi"].opt_prefix
        inreplace lib/"pkgconfig/gobject-2.0.pc" do |s|
          s.gsub! "Requires.private: libffi",
                  "Requires.private: #{libffi}/lib/pkgconfig/libffi.pc"
        end
      end
    end

    rm "gio/completion/.gitignore"
    bash_completion.install (buildpath/"gio/completion").children
    rw_info = python_shebang_rewrite_info(venv.root/"bin/python")
    rewrite_shebang rw_info, *bin.children
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

    assert_match "This file is generated by glib-mkenum", shell_output("#{bin}/glib-mkenums")

    (testpath/"net.Corp.MyApp.Frobber.xml").write <<~EOS
      <node>
        <interface name="net.Corp.MyApp.Frobber">
          <method name="HelloWorld">
            <arg name="greeting" direction="in" type="s"/>
            <arg name="response" direction="out" type="s"/>
          </method>

          <signal name="Notification">
            <arg name="icon_blob" type="ay"/>
            <arg name="height" type="i"/>
            <arg name="messages" type="as"/>
          </signal>

          <property name="Verbose" type="b" access="readwrite"/>
        </interface>
      </node>
    EOS

    system bin/"gdbus-codegen", "--generate-c-code", "myapp-generated",
                                "--c-namespace", "MyApp",
                                "--interface-prefix", "net.corp.MyApp.",
                                "net.Corp.MyApp.Frobber.xml"
    assert_predicate testpath/"myapp-generated.c", :exist?
    assert_match "my_app_net_corp_my_app_frobber_call_hello_world", (testpath/"myapp-generated.h").read
  end
end
