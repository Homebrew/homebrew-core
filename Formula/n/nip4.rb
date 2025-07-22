class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.11/nip4-9.0.11.tar.xz"
  sha256 "6a4ea40987fbb79fe21207c0945114214d235995ed80d50ac54b479eaf0959e9"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "fc149174017606164f3dab6d255af7a454678ed999747a70aa28ae8a3b5320bb"
    sha256 cellar: :any, arm64_sonoma:  "3fa690a5d0898a1e538f95b7fd9184c55209c800d17ce47e391d0aad51409851"
    sha256 cellar: :any, arm64_ventura: "4ccc0df479205109fa0fa61e75ea89b52fb110dd5fea20055d55f7f41f24d8aa"
    sha256 cellar: :any, sonoma:        "f2ce78882251acbf1e128dbeba300620fe08a53e8a5207ee34cdcc30d00e460e"
    sha256 cellar: :any, ventura:       "d1954871ab4841ec490a77a7156cbcc894078ad0a4ea8c63dc91b2a380f80745"
    sha256               arm64_linux:   "5a0751761c842f142161b51ff0d4651842434a822c18f9d02de2b8fb4916a1d6"
    sha256               x86_64_linux:  "4e0f6dd4cf2b935a25e2182feb01efc43f092f3f21d9ec17337d51fce905591c"
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
