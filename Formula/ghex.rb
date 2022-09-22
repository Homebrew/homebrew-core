class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/42/ghex-42.3.tar.xz"
  sha256 "add40f8ab24921db30d27be58f00273201977d87fdc8d79eceadfa8b0e354def"

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

  depends_on "desktop-file-utils" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"

  def install
    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    system "meson", *std_meson_args, "build", "-Dmmap-buffer-backend=#{OS.linux?}"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # (process:30744): Gtk-WARNING **: 06:38:39.728: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"ghex", "--help"
  end
end
