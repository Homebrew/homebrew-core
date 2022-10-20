class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/42/ghex-42.3.tar.xz"
  sha256 "add40f8ab24921db30d27be58f00273201977d87fdc8d79eceadfa8b0e354def"

  bottle do
    sha256 arm64_monterey: "4d7254cc2ef96df2c6187e904e2a63613cfa2963b1c4aa4965f10f49dac318ef"
    sha256 arm64_big_sur:  "c493a5c7d8421dbd84ab8bf8e61ba469fa57afe70f99728a17a95046ccfb85a5"
    sha256 monterey:       "54fe13e40831f5e0032ce82bbded59c5521043e41fcbfed8d532ea2b878e90df"
    sha256 big_sur:        "54c7098a34cbc2cc9c5d32881bf19160fd9506dd81f06c9037036fbd5e08bf4c"
    sha256 catalina:       "b95753839545d3a7e8d664b7afb87cbf4a585635d49fef7ee5cb93ec9e890bd1"
    sha256 x86_64_linux:   "1726f4384ae6dc10dba8cae6bfdb7621abb987fb0390ee7ca8b43bbc597f19a9"
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
