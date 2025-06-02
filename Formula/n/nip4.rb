class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.9-2/nip4-9.0.9-2.tar.xz"
  sha256 "ed3cc21ae581b1b0725c68632ca6a97c21c5cd5169c24c71119daa0b8b026e38"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "94dfc45a48ac1b7a5a59574263a4dc10d227037db8112056b3d2b181422aa24a"
    sha256 cellar: :any, arm64_sonoma:  "9d19a8ad64f055c68aed6c2344ef40ffab5f8acc3d2d6edb2dcea224430fa34a"
    sha256 cellar: :any, arm64_ventura: "29ebfcc9e16dc0b66c52e0a6964df8884e7104779825276768530016038bed94"
    sha256 cellar: :any, sonoma:        "ddf67099c010d19f6cce581d8f351e6c142c9c5f2fa06160b8ad53fb6060b665"
    sha256 cellar: :any, ventura:       "3e008b64a71c9ac42bc162c651f9a0f7b9bf3a341e145ef02a9e4eb42ca122d0"
    sha256               arm64_linux:   "f5011712faacc0538556a0dc6c91ef8088bd7bfb0efe1fb4fdd08618a5790cc8"
    sha256               x86_64_linux:  "c0a0134a2d2b04f8ee1ebe410a0f26b95bc617b28c4a787c556238eaf190fc60"
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
