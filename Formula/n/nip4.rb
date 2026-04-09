class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.18/nip4-9.0.18.tar.xz"
  sha256 "dbef18023b1ac4d38f020a36ce4d2251492bf40f70a640803eef7531a297ecef"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "24e4382577288c165e8bd20b75057ed2437a0eefa99711f195bc8f44955d6915"
    sha256 cellar: :any, arm64_sequoia: "e5b5aa67d524d1c00c093baadd7bfc3f11e461acdb935434d8de1a419f28608f"
    sha256 cellar: :any, arm64_sonoma:  "6101ed695956eef168b9c85a5b47e8cfa0b485607936fce73dc4d971ec281d51"
    sha256 cellar: :any, sonoma:        "ffb35b5dba4f7698c4a6858b0267a9d22bc4b6ad519479de294f67a565778906"
    sha256               arm64_linux:   "7abc440ab11f63de3f91918465e61a01a94ba569df6aa053e4adbe564c8a3c95"
    sha256               x86_64_linux:  "fa06eddf0de63a17475d3963bdeb9c2ffafa6ba0537573535aa3448631a39c12"
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
