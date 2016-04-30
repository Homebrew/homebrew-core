class Libutvideo < Formula
  desc "Ut Video is lossless video codec."
  homepage "http://umezawa.dyndns.info/wordpress/?cat=28"
  url "http://umezawa.dyndns.info/archive/utvideo/utvideo-16.0.0-src.zip"
  sha256 "6ad35cf361d0ca98b96f5990b5008f247a559b10d9341d9752c8abdf6766d4c5"

  depends_on "nasm" => :build

  resource "buildsystem" do
    url "https://github.com/qyot27/libutvideo.git",
           :branch => "buildsystem", :revision => "d2057eb3ea30d99041256a02d64f68d3935847e6"
  end

  def install
    args = %W[--prefix=#{prefix}]
    args << "--enable-asm=" + (MacOS.prefer_64_bit? ? "x64" : "x86")
    resource("buildsystem").stage do
      buildpath.install ["configure", "GNUmakefile", "config.guess", "config.sub"]
    end
    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
