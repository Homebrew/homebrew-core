class Glib < Formula
  include Language::Python::Shebang

  desc "Core application library for C"
  homepage "https://docs.gtk.org/glib/"
  url "https://download.gnome.org/sources/glib/2.90/glib-2.90.0.tar.xz"
  sha256 "17d15cac2af80a33271127408e0abc2748eb297c595c2a26409e81e14e7d1b8f"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  # FIXME: remove livecheck block once `https://download.gnome.org/sources/glib/cache.json` is fixed
  livecheck do
    url "https://download.gnome.org/sources/glib/"
    regex(%r{href="(\d+(?:\.\d+))/"}i)
    strategy :page_match
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "a18b3abe0fc7be6cf0d3119482de99aab576f9657b88252beaa4f78e17418dab"
    sha256 arm64_tahoe:       "04cba8ddae9201ed3e950547bfdde97927e4151da37db32c80f5298bf4d6255f"
    sha256 arm64_sequoia:     "ca168ac34920f6ee13187d8e88af7d55c50b582fa78a5511e15fe9dd875e8b40"
    sha256 arm64_sonoma:      "360e1e14e0db7d9374a2ebc5e0df52c3765e6f42e3d4c8080ac8df8289e181c8"
    sha256 sonoma:            "77ecae9f10b03757b47b6c9dc2e8cadcace52a685dccc0f846871037628e1c3e"
    sha256 arm64_linux:       "9362d75c1ee1db3ebb022d00d20a651e0dcc76293a51ad3182a5293953d14c97"
    sha256 x86_64_linux:      "6e2840b72dee7594f310838f9b0b0b82894eb12e562894b3f1b43563487b9987"
  end

  depends_on "bison" => :build # for gobject-introspection
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python-setuptools" => :build # for gobject-introspection
  depends_on "python@3.14" => :build
  depends_on "pcre2"

  uses_from_macos "flex" => :build # for gobject-introspection
  uses_from_macos "libffi"
  uses_from_macos "python"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "dbus"
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  # These used to live in the now defunct `glib-utils`.
  link_overwrite "bin/gdbus-codegen", "bin/glib-genmarshal", "bin/glib-mkenums", "bin/gtester-report"
  link_overwrite "share/glib-2.0/codegen", "share/glib-2.0/gdb"
  # These used to live in `gobject-introspection`
  link_overwrite "lib/girepository-1.0/GLib-2.0.typelib", "lib/girepository-1.0/GModule-2.0.typelib",
                 "lib/girepository-1.0/GObject-2.0.typelib", "lib/girepository-1.0/Gio-2.0.typelib"
  link_overwrite "share/gir-1.0/GLib-2.0.gir", "share/gir-1.0/GModule-2.0.gir",
                 "share/gir-1.0/GObject-2.0.gir", "share/gir-1.0/Gio-2.0.gir"

  resource "gobject-introspection" do
    url "https://download.gnome.org/sources/gobject-introspection/1.86/gobject-introspection-1.86.0.tar.xz"
    sha256 "920d1a3fcedeadc32acff95c2e203b319039dd4b4a08dd1a2dfd283d19c0b9ae"

    livecheck do
      formula "gobject-introspection"
    end
  end

  # replace several hardcoded paths with homebrew counterparts
  patch do
    file "Patches/glib/hardcoded-paths.diff"
  end

  deny_network_access!

  def install
    # Avoid the sandbox violation when an empty directory is created outside of the formula prefix.
    inreplace "gio/meson.build", "install_emptydir(glib_giomodulesdir)", ""

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    # and https://gitlab.gnome.org/GNOME/glib/-/issues/653
    args = %W[
      --localstatedir=#{var}
      -Dgio_module_dir=#{HOMEBREW_PREFIX}/lib/gio/modules
      -Dbsymbolic_functions=false
      -Ddtrace=disabled
      -Druntime_dir=#{var}/run
      -Dtests=false
    ]

    # Stage build in order to deal with circular dependency as `gobject-introspection`
    # is needed to generate `glib` introspection data used by dependents; however,
    # `glib` is a dependency of `gobject-introspection`.
    # Ref: https://discourse.gnome.org/t/dealing-with-glib-and-gobject-introspection-circular-dependency/18701
    staging_dir = buildpath/"staging"
    staging_meson_args = std_meson_args(prefix: staging_dir)
    system "meson", "setup", "build_staging", "-Dintrospection=disabled", *args, *staging_meson_args
    system "meson", "compile", "-C", "build_staging", "--verbose"
    system "meson", "install", "-C", "build_staging"

    ENV.append_path "PKG_CONFIG_PATH", staging_dir/"lib/pkgconfig"
    ENV.append_path "LD_LIBRARY_PATH", staging_dir/"lib" if OS.linux?
    ENV.append_path "PATH", staging_dir/"bin"

    resource("gobject-introspection").stage do
      system "meson", "setup", "build", "-Dcairo=disabled", "-Ddoctool=disabled", "-Dtests=false", *staging_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end

    system "meson", "setup", "build", "--default-library=both", "-Dintrospection=enabled", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # ensure giomoduledir contains prefix, as this pkgconfig variable will be
    # used by glib-networking and glib-openssl to determine where to install
    # their modules
    inreplace lib/"pkgconfig/gio-2.0.pc",
              "giomoduledir=#{HOMEBREW_PREFIX}/lib/gio/modules",
              "giomoduledir=${libdir}/gio/modules"

    bash_completion.install (share/"bash-completion/completions").children
    return unless OS.mac?

    # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
    # have a pkgconfig file, so we add gettext lib and include paths here.
    inreplace lib/"pkgconfig/glib-2.0.pc" do |s|
      s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
              "Libs: -L${libdir} -lglib-2.0 -L#{formula_opt_lib("gettext")} -lintl"
      s.gsub! "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include",
              "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{formula_opt_include("gettext")}"
    end
  end

  post_install_steps do
    mkdir_p "{{HOMEBREW_PREFIX}}/lib/gio/modules"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    flags = shell_output("pkgconf --cflags --libs glib-2.0").chomp.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"

    assert_match "This file is generated by glib-mkenum", shell_output(bin/"glib-mkenums")

    (testpath/"net.Corp.MyApp.Frobber.xml").write <<~XML
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
    XML

    system bin/"gdbus-codegen", "--generate-c-code", "myapp-generated",
                                "--c-namespace", "MyApp",
                                "--interface-prefix", "net.corp.MyApp.",
                                "net.Corp.MyApp.Frobber.xml"
    assert_path_exists testpath/"myapp-generated.c"
    assert_match "my_app_net_corp_my_app_frobber_call_hello_world", (testpath/"myapp-generated.h").read

    # Keep (u)int64_t and g(u)int64 aligned. See install comment for details
    (testpath/"typecheck.cpp").write <<~CPP
      #include <cstdint>
      #include <type_traits>
      #include <glib.h>

      int main()
      {
        static_assert(std::is_same<int64_t, gint64>::value == true, "gint64 should match int64_t");
        static_assert(std::is_same<uint64_t, guint64>::value == true, "guint64 should match uint64_t");
        return 0;
      }
    CPP
    system ENV.cxx, "-o", "typecheck", "typecheck.cpp", "-I#{include}/glib-2.0", "-I#{lib}/glib-2.0/include"
  end
end
