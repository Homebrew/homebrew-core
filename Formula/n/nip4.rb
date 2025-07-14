class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.10-1/nip4-9.0.10-1.tar.xz"
  sha256 "1439698adb1e4bff149d77c40d180b2b9b03d30283df2f842fbaefc973f8c36c"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "d515083872b8e16bfb40ae41c2cb3590a1be1ab13af3a66fde1c36e6af502d77"
    sha256 cellar: :any, arm64_sonoma:  "7b77a2288a3715753e14b88e2aad9ab87b3fcec2c5449da53c88f7734c071440"
    sha256 cellar: :any, arm64_ventura: "5449572026bb559ae7df645ddb5b9d4c44b6878b1b5375a9a9f0309a154b1ca7"
    sha256 cellar: :any, sonoma:        "246e75a16058579dfb11eb0d9977636580474f7109d9f82ae86ed8ef18c3140b"
    sha256 cellar: :any, ventura:       "f72a601d0c82d33e94a7fef6bcc4018363366e12b3a0c7455fe9a5d8b97ed517"
    sha256               arm64_linux:   "3d8a3f2606868a12cc548a9d0d7d345659a22fe6af31eab8183f26dc1e3799b4"
    sha256               x86_64_linux:  "2a326517de7b3a116ead086e46f91f5543a8ca5825f93f6bd469577164c6b311"
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
