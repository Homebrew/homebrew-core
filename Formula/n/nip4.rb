class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.1.5/nip4-9.1.5.tar.xz"
  sha256 "ceea7a00f9e8182195c3b4a62416145dbc303f44f62a09bfce0690fd6fbf1ecc"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "017dff0866a42a3e1506bd2770aaa8b1203a56de831fb61366fd21c6b17814da"
    sha256 cellar: :any, arm64_sequoia: "4117bf9acac83f6aae59832b66d4d56d03c23098142c17953913e271d5772a5a"
    sha256 cellar: :any, arm64_sonoma:  "02b535b1c024e0e23218521e4a57882d9dda35d38633f819ad6eedf97fc0eacb"
    sha256 cellar: :any, sonoma:        "b6101aea8442cffafab0bcb3f5d7c56369bf92ba1264b8f36a7d4034ba061fd5"
    sha256               arm64_linux:   "d68a533b106fe2766d85c2c3eca7686b198f9f37f5c5549a6c56d23b11618f17"
    sha256               x86_64_linux:  "7054d92e943815142bca7e1873b7135bd2a0423ed018348d0175d933c6e92a0f"
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
