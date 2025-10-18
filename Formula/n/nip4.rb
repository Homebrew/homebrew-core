class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.13-2/nip4-9.0.13-2.tar.xz"
  sha256 "ab144b3702eb2376b58df9c39c9a53161e6960fea4c7c71eb5e5fd9cab9af1e1"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7f12dc7ac73e81bdae035ab1cbd8b299b870c419a626a695c955890e18c19176"
    sha256 cellar: :any, arm64_sequoia: "9bcd462222196e81f2dea6a0a35ba7624f27dc02c1fb878cfce9dcea0e713902"
    sha256 cellar: :any, arm64_sonoma:  "794eb9cd73584956939380cfe338fb8793a0fc298deab405793aa22a149a72b5"
    sha256 cellar: :any, sonoma:        "d4d0b55419abfb5b00c853249fdbdc8ae17dbb0ec69e0df5188550103bc11280"
    sha256               arm64_linux:   "208965f1f47bfd67cfcb24297096a66b3a4c31129d2646d4a49096781b45a59d"
    sha256               x86_64_linux:  "037054fd39b519ff9032abc5b62e874cd49519f5a5b14b45f109578c4b7f821d"
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
