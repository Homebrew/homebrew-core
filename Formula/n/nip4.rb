class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.1.2/nip4-9.1.2.tar.xz"
  sha256 "40a627bf6046965d800b1dd44b6c30d37f0ab15c413cb1dc6150cd72dbd48179"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "06e97c03609a98eb49585c74ff372e9968210c266e6c97601822a93cca56e327"
    sha256 cellar: :any, arm64_sequoia: "eacab64741f88399a02bafe2a9d1572610f74bbca7622644cbfff36908129b1d"
    sha256 cellar: :any, arm64_sonoma:  "0a99aa7dd19baa046fd2f50a3609160dab17fe6c589ce683dd1dd820bd33ba5b"
    sha256 cellar: :any, sonoma:        "8774883ee21a47975518e17f98cad4a8d739dbdf98be23883e02082be06b3f96"
    sha256               arm64_linux:   "c7a0e74fc583b15732d0c188d821ce7069498108cfc429b43421c65d5e0d1013"
    sha256               x86_64_linux:  "fe183ac1d0e3b7433aae860771cf1a9268d41e066568fa526259236bb1003378"
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
