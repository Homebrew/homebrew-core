class Libglib < Formula
  desc "Core application library for C"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.72/glib-2.72.2.tar.xz"
  sha256 "78d599a133dba7fe2036dfa8db8fb6131ab9642783fc9578b07a20995252d2de"
  license "LGPL-2.1-or-later"

  livecheck do
    formula "glib"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "gettext"
  depends_on "pcre"

  uses_from_macos "libffi"

  on_linux do
    depends_on "util-linux"
  end

  def install
    # TODO: This is a workaround for `brew audit --new-formula`.
    #       Use `patch` rather than `inreplace` (see also `glib`).
    # replace several hardcoded paths with homebrew counterparts
    inreplace "gio/xdgmime/xdgmime.c",
              'xdg_data_dirs = "/usr/local/share/:/usr/share/";',
              "xdg_data_dirs = \"#{HOMEBREW_PREFIX}/share/:/usr/local/share/:/usr/share/\";"
    inreplace "glib/gutils.c",
              'data_dirs = "/usr/local/share/:/usr/share/";',
              "data_dirs = \"#{HOMEBREW_PREFIX}/share/:/usr/local/share/:/usr/share/\";"

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    # and https://gitlab.gnome.org/GNOME/glib/-/issues/653
    args = std_meson_args + %W[
      --default-library=both
      --localstatedir=#{var}
      -Diconv=auto
      -Dgio_module_dir=lib/gio/modules
      -Dbsymbolic_functions=false
      -Ddtrace=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    if OS.mac?
      # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
      # have a pkgconfig file, so we add gettext lib and include paths here.
      gettext = Formula["gettext"]
      inreplace lib+"pkgconfig/glib-2.0.pc" do |s|
        s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
                "Libs: -L${libdir} -lglib-2.0 -L#{gettext.opt_lib} -lintl"
        s.gsub! "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include",
                "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{gettext.opt_include}"
      end
    end

    # `pkg-config --print-requires-private gobject-2.0` includes libffi,
    # but that package is keg-only so it needs to look for the pkgconfig file
    # in libffi's opt path.
    libffi = Formula["libffi"]
    inreplace lib+"pkgconfig/gobject-2.0.pc" do |s|
      s.gsub! "Requires.private: libffi",
              "Requires.private: #{libffi.opt_lib}/pkgconfig/libffi.pc"
    end

    # These are provided by `glib`.
    rm_rf bin
    rm_rf share
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
