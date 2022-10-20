class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.47.tar.xz"
  sha256 "61da23b1bc6c7a593fdc28611932cd7a30fcf6803830e01764c29b8abed2249c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "aec50d0abded66abe0782d7a3d0c94f007291d84b079403f6ca16c607d6a9664"
    sha256 arm64_big_sur:  "e1a0648cf06fb9ba732c6497fb0cce1e0b96df792d6409dc8ee6e887a9b5d47a"
    sha256 monterey:       "0ae2a4cb662029810c25445e6a366ae20f86fef1580cf234cea684623e6d913f"
    sha256 big_sur:        "a77af252303f0924453a66abbec8bf257a680f7750b3c70d1cd6d5dae930efdd"
    sha256 catalina:       "1eb81a8f44f8f16e2ecf7b9095933e348a814a9d6a043045c98c56b26a3135f5"
    sha256 x86_64_linux:   "ffc6bd90510385423afec07c18847a2d5a6089333e7e8899d1814be90dcf8d73"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libmpdclient"
  depends_on "pcre2"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", "-Dcolors=false", "-Dnls=enabled", "-Dregex=enabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
