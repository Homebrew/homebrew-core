class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.8-2/nip4-9.0.8-2.tar.xz"
  sha256 "d15453bdafaf46093e210c27c0f5c1abed29c0d2ec157400b35bac9b3eca1b9b"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "1a0d17abf55ba7785f5304339f23864d36b2eb2842b9ae45a35bb36cda504165"
    sha256 cellar: :any, arm64_sonoma:  "e68839e250be2b23a86d924436680aeea9d9ce6a841810ca51bb9fc876bdd8b4"
    sha256 cellar: :any, arm64_ventura: "66bae0981443edff45c5257483ba237b1276b921e4cf6ac307ef8942842bfe75"
    sha256 cellar: :any, sonoma:        "284343572d69807ed796087e5fef71a22ff817bf451babd7e5365466ea870181"
    sha256 cellar: :any, ventura:       "dcd89305c680dbd3e40094666d8bb0982f52ddcd7138c848662804dc03c570db"
    sha256               arm64_linux:   "2ac0ab2cbb24405e1cc55444914444dd924edfcec07c5d0cfeae08221744c143"
    sha256               x86_64_linux:  "b8eab0f1a7d56a692b96ef495bc8ebf17f2028ae03295f9d6bbf6e3cdfb7d289"
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
