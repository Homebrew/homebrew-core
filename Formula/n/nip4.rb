class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.12/nip4-9.0.12.tar.xz"
  sha256 "f778f5c7183c30048d1297820aff051a3248d039af6ed96bbd214b5fc7b7a91c"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d33500b816ba2a0c3533dc9149ab00c3d11609b6585b80838eefdfa38b1dcd49"
    sha256 cellar: :any, arm64_sequoia: "298f7893d253f89fc787280841e5c77b44654b699266b093137caf56941ede0d"
    sha256 cellar: :any, arm64_sonoma:  "7aae889a9226e5bc3d5b1f8dd3ad252d137974608a59fa502c102713ef643c6d"
    sha256 cellar: :any, arm64_ventura: "ce5a68cda79d47f13f1e738a55049f08fff0aa4a9cc9ed5ec28e283d92092ebd"
    sha256 cellar: :any, sonoma:        "fdb16d697088b7b3da97c80a79ff6f813be685a886d0bf605b87f5d99caf8238"
    sha256 cellar: :any, ventura:       "85f94778fae3e836292d16221fe71495161836b97465a9995e73fd70eb251b16"
    sha256               arm64_linux:   "944fc4d927cb8dffb779a0cf2d3b9959f26cdbee6b4cb8a552c3c45a11dd0799"
    sha256               x86_64_linux:  "e28914b8a1a0a4577fdd20164c42267b5cc256042c090cf04af835f9db2a7eb3"
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
    assert_match version.to_s, shell_output("#{bin}/nip4 --version")

    # nip4 is a GUI application
    spawn bin/"nip4" do |_r, _w, pid|
      sleep 5
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
