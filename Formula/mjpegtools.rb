class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "https://mjpeg.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.1.0/mjpegtools-2.1.0.tar.gz"
  sha256 "864f143d7686377f8ab94d91283c696ebd906bf256b2eacc7e9fb4dddcedc407"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0903181fb61252feccfb8d40a390a7d5c55ed1476d37d040983e5608efeaee1b"
    sha256 cellar: :any, big_sur:       "ff8f81930169f7581677b690fbc32ba8c3f818ca139fe4249c8606f309a0e298"
    sha256 cellar: :any, catalina:      "5628d3b16a0e3172ba49a38b903b5be2fcb2595ce4919e32c41e39a89a250102"
    sha256 cellar: :any, mojave:        "c8a22d895e9835274994bdf72b0ca6f3c0df523e5dc8e281ed7d1fd7ae3b41eb"
    sha256 cellar: :any, high_sierra:   "7f47c9df784de38ee02726c1381b42a5924754c7702003ee8fafbae296302638"
    sha256 cellar: :any, sierra:        "9f5c0eb81540bf70ff8b2352a8ea21117a75c6dbdac58ea8d04d0da47a639cb9"
    sha256 cellar: :any, el_capitan:    "2793d05c642305daeb9cceb10f08484ce57d5210a3918121ab04be1f89224142"
    sha256 cellar: :any, yosemite:      "ba1ec63066197a9bb7fc53f075b17d66f739936b151e90e39a741b33f19eaa9f"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-simd-accel",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
