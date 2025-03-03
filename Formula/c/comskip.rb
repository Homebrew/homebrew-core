class Comskip < Formula
  desc "Free commercial detector"
  homepage "https://www.comskip.org"
  url "https://github.com/erikkaashoek/Comskip/archive/refs/tags/V0.83.tar.gz"
  sha256 "bd90d7922916e0b04ea9f3426ea7747d347f218f3f915fb4d251961d0730876e"
  license "GPL-2.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "argtable"
  depends_on "ffmpeg"
  depends_on "sdl2"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # Download a test mkv and check the output from comskip without using an ini file

    resource "testdata" do
      url "https://s3.amazonaws.com/tmm1/ten-copy.mkv"
      sha256 "250cf9360676e66db96231d0ea690545325f9bfbbf139f638f7dc5c41525ff5d"
    end

    resource("testdata").stage do
      system bin/"comskip", "ten-copy.mkv"
      system "grep \"9361\\s17922\" ten-copy.txt 2>&1 /dev/null"
    end
  end
end
