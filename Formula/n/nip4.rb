class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.1.1/nip4-9.1.1.tar.xz"
  sha256 "545643689e2af75d84ca569d2ccda569d3c4236b2fa631c51b64a89121554979"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c1d32b463ccdbb33099ef1906f435ac2a4b67f5b629ea1fa98ce0b26555ce52d"
    sha256 cellar: :any, arm64_sequoia: "8c87da5fd58f6baacabab93de9adaf6b55147c40d2f9a7e13ce88af844fdab65"
    sha256 cellar: :any, arm64_sonoma:  "1241af1ff353460ee15bffddc8354b9cf7ec65b41db3864a4c5c557c475b9303"
    sha256 cellar: :any, sonoma:        "8debce9f064e70ac1e0053ac9eda4a28bf2d77c21c8ddada963d48a2e5c83420"
    sha256               arm64_linux:   "34bf43336f1fca5e1713a27a52eb256a4b240c7cd6325bbccb454a9c54209cf5"
    sha256               x86_64_linux:  "f35b39359d15f752dbe39743d168a6a439e17a8824c5c2f7d8315a02e076756f"
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
