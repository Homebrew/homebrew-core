class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "https://mjpeg.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.1.0/mjpegtools-2.1.0.tar.gz"
  sha256 "864f143d7686377f8ab94d91283c696ebd906bf256b2eacc7e9fb4dddcedc407"
  revision 2

  bottle do
    cellar :any
    sha256 "9f5c0eb81540bf70ff8b2352a8ea21117a75c6dbdac58ea8d04d0da47a639cb9" => :sierra
    sha256 "2793d05c642305daeb9cceb10f08484ce57d5210a3918121ab04be1f89224142" => :el_capitan
    sha256 "ba1ec63066197a9bb7fc53f075b17d66f739936b151e90e39a741b33f19eaa9f" => :yosemite
  end

  depends_on :x11 => :optional

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libquicktime" => :optional
  depends_on "libdv" => :optional
  depends_on "gtk+" => :optional
  depends_on "sdl_gfx" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-simd-accel",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
