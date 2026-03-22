class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.17/nip4-9.0.17.tar.xz"
  sha256 "a34915962bc2c0253575afda1caa8df5c8795d06d63cf71ec2c747ec627594c4"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4131b345acda2b46c787b53a13fb23193df905c3fe8b84ba4d21544f677be0cd"
    sha256 cellar: :any, arm64_sequoia: "bcc2ee5ab1adf981090b76f6597fcfa3f85924ff23d4a76d7ae47a633d562dc3"
    sha256 cellar: :any, arm64_sonoma:  "5b141cfd46021660b8da587777f9060db979c01906f94653a4ff7f607a0735ab"
    sha256 cellar: :any, sonoma:        "1e3c52d741422d3543a959ecaa5f3ee70003179ecd8f1c5d6ee1436edd81abe7"
    sha256               arm64_linux:   "fb20cb2ca0ead0b99e4756dcb766482fcbc9bbae4cfe1cb73223ddac4b26701d"
    sha256               x86_64_linux:  "00d87bbfae7ba12dcd5cc7e5f28b30bac88c69f888e014fea552c97d048022ac"
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
