class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.16/nip4-9.0.16.tar.xz"
  sha256 "1af13d06923bfc4d1dc9ce988da1d7ef3981b0ed77958f50831bcf5cef3f0861"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "26a639749c5a24e3c675ff1036869510e860a39586d4ca05ce6db8487b23a8b6"
    sha256 cellar: :any, arm64_sequoia: "d531b32a8ad1704ea73b571e603e4e4cb522e982c05e7f243447d5908e47ed01"
    sha256 cellar: :any, arm64_sonoma:  "52b7e756881153f14e9ca96f38cf3831606256e1c8f179a21c93899bb94300ab"
    sha256 cellar: :any, sonoma:        "3e94f33c52c3cf5fb8934b121769f7697073fcf2740132fb2097b200cf96edfc"
    sha256               arm64_linux:   "e63a659ac2135cd184c7ba63dfdafbc48815901140e7878d317f6053009051fc"
    sha256               x86_64_linux:  "a621a0bb45909bdfc3e7792879eb288177bcfcddfaa11225c3f5fa6303764df2"
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
