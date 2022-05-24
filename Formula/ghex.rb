class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/3.18/ghex-3.18.4.tar.xz"
  sha256 "c2d9c191ff5bce836618779865bee4059db81a3a0dff38bda3cc7a9e729637c0"
  revision 3

  bottle do
    sha256 arm64_monterey: "292f84d1b19188dcb9b6ad7e8c812e1b4bb0189fbf377009118905daa4db7017"
    sha256 arm64_big_sur:  "0b3953f55c7d99378104344d01d3f3207cf4e0f8364906c90561ca43484e9d34"
    sha256 monterey:       "617fc014643a58da71c63bc935d01589c3f0df7b257c840a32250a9303556917"
    sha256 big_sur:        "3c7a8c7f133ff63b1398074340ed06140645d258b94e971d897f912b8631f609"
    sha256 catalina:       "b152b5f03f5bc0d7a50a834fef582ea7fb477dd7560afb4a0b1f4df88e229970"
    sha256 mojave:         "c2e68caac31470d6dbc66050b2dc42333b3dfc6956ee7453fba9032b5cf894a4"
    sha256 high_sierra:    "4de4a0a7ee3f81c7f7b36d7368380b2ff2a063c5d444302cd5979ee33727fb1c"
    sha256 x86_64_linux:   "162e20b386fe920b63142876b0e0100a471d69b9737c516a9c30ed04b27d5801"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

  # submitted upstream as https://gitlab.gnome.org/GNOME/ghex/merge_requests/8
  patch :DATA

  def install
    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/ghex", "--help"
  end
end

__END__
diff --git a/src/meson.build b/src/meson.build
index fdcdcc2..ac45c93 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -23,9 +23,9 @@ libghex_c_args = [
   '-DG_LOG_DOMAIN="libgtkhex-3"'
 ]

-libghex_link_args = [
+libghex_link_args = cc.get_supported_link_arguments([
   '-Wl,--no-undefined'
-]
+])

 install_headers(
   libghex_headers,
@@ -36,6 +36,7 @@ libghex = library(
   'gtkhex-@0@'.format(libghex_version_major),
   libghex_sources + libghex_headers,
   version: '0.0.0',
+  darwin_versions: ['1', '1.0'],
   include_directories: ghex_root_dir,
   dependencies: libghex_deps,
   c_args: libghex_c_args,
