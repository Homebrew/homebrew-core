class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/41/gedit-41.0.tar.xz"
  sha256 "7a9b18b158808d1892989165f3706c4f1a282979079ab7458a79d3c24ad4deb5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "944db5b9131011efb9ac1ca370342b21895bc8c2220138c90fd137cc883ccc1e"
    sha256 big_sur:       "7cee9c8a408d1f8bfc28f05475babd0e9d0236cfb2411042c56112c97d6ccbd7"
    sha256 catalina:      "f36d6723b16e6271e0c5327b6d7723ed501c51bd1ab07a4c3c125ed877ff4e99"
    sha256 mojave:        "5a842c19e3ff549f23d6854265423064666686548356d0c188df63b741d49d77"
    sha256 x86_64_linux:  "43fd433db4952cba82e79d384f06abc89d5dbd46d8ed6b37fca84a002ebadff4"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "libpeas"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "pango"

  # Fix build error due to missing function 'gedit_dirs_get_user_cache_dir'
  # ../gedit/gedit-app.c:675:14: error: implicit declaration of function 'gedit_dirs_get_user_cache_dir'
  # TODO: Remove in the next release
  patch do
    url "https://gitlab.gnome.org/GNOME/gedit/-/commit/741be1b11b977abd529aa2f633e50c2e80864afc.diff"
    sha256 "e5ffa72b430abe60b357286c7079e8da9da1a05c31c023cb0f6885ed9c69e4cf"
  end

  # Fix build error due to missing file 'gedit-recent-osx.c'
  # ../gedit/meson.build:182:0: ERROR: File gedit-recent-osx.c does not exist.
  # PR ref: https://gitlab.gnome.org/GNOME/gedit/-/merge_requests/128
  # TODO: Remove when PR is merged and available in release
  patch do
    url "https://gitlab.gnome.org/GNOME/gedit/-/commit/b075623f0d21f9d960999aa6dfc2a1072b7f12aa.diff"
    sha256 "e82c3b38c17887313b9d6d88254427cba3fbbca259571bfa318fcaf917b13143"
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/gedit" if OS.linux?

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    # main executable test
    system bin/"gedit", "--version"
    # API test
    (testpath/"test.c").write <<~EOS
      #include <gedit/gedit-debug.h>

      int main(int argc, char *argv[]) {
        gedit_debug_init();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs gedit").chomp.split
    flags << "-Wl,-rpath,#{lib}/gedit" if OS.linux?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
