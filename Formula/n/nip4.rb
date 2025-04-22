class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.6/nip4-9.0.6.tar.xz"
  sha256 "31d0d45afc133c1f036d1e65a833ff530f4ec6ff9c34a0aa3189eb219f784627"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "de2e3e8859eb477aeaf7811d5c54e5c6830ad737c9a178f270d3198ff79f50ca"
    sha256 cellar: :any, arm64_sonoma:  "5f8656a100522f979801ac5ee8614c47052a17742084e2a6b9bb75ad83913e13"
    sha256 cellar: :any, arm64_ventura: "211088d115486b72baad02d86d0ebff6bf8dc1378add51e0cdb58ae53510576f"
    sha256 cellar: :any, sonoma:        "c26a1e073698c9e388b53aa317cd0b2b8733bc54977a26a64a23305b68ac419f"
    sha256 cellar: :any, ventura:       "d7962fdaa791a4b27bc03c5fb295aea2b70b94517c1a9a5c9249da0b16e2a571"
    sha256               arm64_linux:   "2b29492084062295f6a7e7a9f65179a38ecf3ce126885f24859c0e3f5089a80e"
    sha256               x86_64_linux:  "8daa844dd42161258390b18d74012464b0a860b60355626b766bbf987ddbde89"
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
