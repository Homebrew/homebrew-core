class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/42/ghex-42.0.tar.xz"
  sha256 "2f2d7554ef128a6c68009d986394e204c31678c53e1d4a409f219098d4bfc9bb"

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
  depends_on "gtk+4"
  depends_on "hicolor-icon-theme"

  # ignore `gnome.post_install`
  patch :DATA

  def install
    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dmmap-buffer-backend=false", ".."
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
diff --git a/meson.build b/meson.build
index 94adbad..85e1e84 100644
--- a/meson.build
+++ b/meson.build
@@ -146,11 +146,6 @@ subdir('icons')
 subdir('po')
 subdir('help')

-gnome.post_install(
-  glib_compile_schemas: true,
-  gtk_update_icon_cache: true,
-  update_desktop_database: true,
-)

 ### SUMMARY PRINTOUT ###
