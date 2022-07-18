class Glib < Formula
  include Language::Python::Shebang

  desc "Core application library for C"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.72/glib-2.72.3.tar.xz"
  sha256 "4a39a2f624b8512d500d5840173eda7fa85f51c109052eae806acece85d345f0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "af335e6bfa338341ac2c97e7da0f5d1c4191d28acda36b5ce4b2720e875f02bf"
    sha256 arm64_big_sur:  "60e0ef5296fbec04c0ed32409d6439a0dbcbbd68c5907769777b14f984088fbf"
    sha256 monterey:       "528f8a75879a9e52ea0a9ab65c018e01333514e22d1b70896be8ff3b96b35189"
    sha256 big_sur:        "504908c9397c17f97cdf7b32ddbbdc7ac0af4a13937ba83161cb85f8f06b2c75"
    sha256 catalina:       "151fedd4c8545530c9a8b750ffb6b189db50ce95239ca03d1ec98bf7feefeb55"
    sha256 x86_64_linux:   "5b23356a0c0fbaea9fb96554e7a2a8d5bab0f16c050acae1df7fa50f344fd32b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "gettext"
  depends_on "libffi"
  depends_on "pcre"

  on_linux do
    depends_on "util-linux"
  end

  # Sync this with `glib-utils.rb`
  # replace several hardcoded paths with homebrew counterparts
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/43467fd8dfc0e8954892ecc08fab131242dca025/glib/hardcoded-paths.diff"
    sha256 "d81c9e8296ec5b53b4ead6917f174b06026eeb0c671dfffc4965b2271fb6a82c"
  end

  def install
    inreplace %w[gio/xdgmime/xdgmime.c glib/gutils.c],
      "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    # and https://gitlab.gnome.org/GNOME/glib/-/issues/653
    args = std_meson_args + %W[
      --default-library=both
      --localstatedir=#{var}
      -Diconv=auto
      -Dgio_module_dir=#{HOMEBREW_PREFIX}/lib/gio/modules
      -Dbsymbolic_functions=false
      -Ddtrace=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    # ensure giomoduledir contains prefix, as this pkgconfig variable will be
    # used by glib-networking and glib-openssl to determine where to install
    # their modules
    inreplace lib/"pkgconfig/gio-2.0.pc",
              "giomoduledir=#{HOMEBREW_PREFIX}/lib/gio/modules",
              "giomoduledir=${libdir}/gio/modules"

    # Delete python files because they are provided by `glib-utils`
    python_extension_regex = /\.(py(?:[diwx])?|px[di]|cpython-(?:[23]\d{1,2})[-\w]*\.(so|dylib))$/i
    python_shebang_regex = %r{^#! ?/usr/bin/(?:env )?python(?:[23](?:\.\d{1,2})?)?( |$)}
    shebang_max_length = 28 # the length of "#! /usr/bin/env pythonx.yyy "
    prefix.find do |f|
      next unless f.file?

      f.unlink if python_extension_regex.match?(f.basename) || python_shebang_regex.match?(f.read(shebang_max_length))
    end

    # Delete empty directories
    # Note: We need to traversal the directories in reverse order (i.e. deepest first).
    #       Also, we should put checking emptiness and deletion in a single loop.
    #       `dirs.select(&:empty?).map(&:rmdir)` will not work because it will not delete
    #       directories that only contain empty directories.
    prefix.find.select(&:directory?).reverse_each { |d| d.rmdir if d.empty? }

    if OS.mac?
      # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
      # have a pkgconfig file, so we add gettext lib and include paths here.
      gettext = Formula["gettext"].opt_prefix
      inreplace lib+"pkgconfig/glib-2.0.pc" do |s|
        s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
                "Libs: -L${libdir} -lglib-2.0 -L#{gettext}/lib -lintl"
        s.gsub! "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include",
                "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{gettext}/include"
      end
    end

    # `pkg-config --print-requires-private gobject-2.0` includes libffi,
    # but that package is keg-only so it needs to look for the pkgconfig file
    # in libffi's opt path.
    libffi = Formula["libffi"].opt_prefix
    inreplace lib+"pkgconfig/gobject-2.0.pc" do |s|
      s.gsub! "Requires.private: libffi",
              "Requires.private: #{libffi}/lib/pkgconfig/libffi.pc"
    end

    bash_completion.install Dir["gio/completion/*"]
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/gio/modules").mkpath
  end

  def caveats
    <<~EOS
      Python executables and libraries are no longer included with this formula, but they are available separately:
        brew install glib-utils
    EOS
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
