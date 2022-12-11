class Glib < Formula
  include Language::Python::Shebang

  desc "Core application library for C"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.74/glib-2.74.4.tar.xz"
  sha256 "0e82da5ea129b4444227c7e4a9e598f7288d1994bf63f129c44b90cfd2432172"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "9a34e6ef3d80de01678b341b716385bf08edda59db6deef0a519be28aa4835ee"
    sha256 arm64_monterey: "2476e85f3c4fd1648bb09efbdf812aba44b4af1723205e2376ad5ff787d2d60d"
    sha256 arm64_big_sur:  "494f7a802d78309d6420ae7d113c65189e09e7a5851320ddb493a7f0dfb2bf4e"
    sha256 ventura:        "8f12510a26c045ae316ff0670c4dc1faf55d0a6ee12986bd4790e07f48b6d955"
    sha256 monterey:       "55aebc872575b6c4a49bc8b45755b030bc0cedd258f955adfd2d44c15cccdc20"
    sha256 big_sur:        "8c7b072925ba9cbf0f4d886a9da404102a4d4c530806319e1094ffdae16337d5"
    sha256 x86_64_linux:   "d896a5a0f3b720819fd86a85a95c7385b50212918ef9d7db8adb5750e2c2ed99"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre2"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "python", since: :catalina

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
  end

  # These used to live in the now defunct `glib-utils`.
  link_overwrite "bin/gdbus-codegen", "bin/glib-genmarshal", "bin/glib-mkenums", "bin/gtester-report"
  link_overwrite "share/glib-2.0/codegen", "share/glib-2.0/gdb"

  # replace several hardcoded paths with homebrew counterparts
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/43467fd8dfc0e8954892ecc08fab131242dca025/glib/hardcoded-paths.diff"
    sha256 "d81c9e8296ec5b53b4ead6917f174b06026eeb0c671dfffc4965b2271fb6a82c"
  end

  def install
    inreplace %w[gio/xdgmime/xdgmime.c glib/gutils.c], "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    # and https://gitlab.gnome.org/GNOME/glib/-/issues/653
    args = %W[
      --default-library=both
      --localstatedir=#{var}
      -Diconv=auto
      -Dgio_module_dir=#{HOMEBREW_PREFIX}/lib/gio/modules
      -Dbsymbolic_functions=false
      -Ddtrace=false
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

    rm "gio/completion/.gitignore"
    bash_completion.install (buildpath/"gio/completion").children
    rewrite_shebang detected_python_shebang(use_python_from_path: true), *bin.children
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
