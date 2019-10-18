class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "https://mjpeg.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.1.0/mjpegtools-2.1.0.tar.gz"
  sha256 "864f143d7686377f8ab94d91283c696ebd906bf256b2eacc7e9fb4dddcedc407"
  revision 2

  bottle do
    cellar :any
    sha256 "5628d3b16a0e3172ba49a38b903b5be2fcb2595ce4919e32c41e39a89a250102" => :catalina
    sha256 "c8a22d895e9835274994bdf72b0ca6f3c0df523e5dc8e281ed7d1fd7ae3b41eb" => :mojave
    sha256 "7f47c9df784de38ee02726c1381b42a5924754c7702003ee8fafbae296302638" => :high_sierra
    sha256 "9f5c0eb81540bf70ff8b2352a8ea21117a75c6dbdac58ea8d04d0da47a639cb9" => :sierra
    sha256 "2793d05c642305daeb9cceb10f08484ce57d5210a3918121ab04be1f89224142" => :el_capitan
    sha256 "ba1ec63066197a9bb7fc53f075b17d66f739936b151e90e39a741b33f19eaa9f" => :yosemite
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
