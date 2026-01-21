class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.15/nip4-9.0.15.tar.xz"
  sha256 "25145902a5ef15ca1519c37556e2fb80c88b5b639a8656abfac3e17a62fafa22"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e5008a8303028c2def9ab592f4b45345f5b6e777c7e8a8117b2c58efc25f49ac"
    sha256 cellar: :any, arm64_sequoia: "f95cd85e09bfe12d81cc6054cee084e4886714b02f2597a986cee3e2afc40a8f"
    sha256 cellar: :any, arm64_sonoma:  "0456a069cc8fd5ffafacd9a5d7926fd6fc27b3ab5aa5f86dae62493c2e1f50ee"
    sha256 cellar: :any, sonoma:        "9709586e7fa074645b916aee3fb0dd970a2af51668969bfab45364a8b8132596"
    sha256               arm64_linux:   "730edd5aaebd9e931ea587dcbd1c206d146586f580eec2d605f9103cc6456843"
    sha256               x86_64_linux:  "6f46e8825435fb74b6b4796d4aaf51d297fb1a4f14fdda7e21fcddb8351a9333"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gsl"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libxml2"
  depends_on "pango"
  depends_on "vips"

  def install
    # Avoid running `meson` post-install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/nip4 --version")

    # nip4 is a GUI application
    spawn bin/"nip4" do |_r, _w, pid|
      sleep 5
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
