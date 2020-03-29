class Libowfat < Formula
  desc "Reimplements libdjb"
  homepage "https://www.fefe.de/libowfat/"
  url "https://www.fefe.de/libowfat/libowfat-0.32.tar.xz"
  sha256 "f4b9b3d9922dc25bc93adedf9e9ff8ddbebaf623f14c8e7a5f2301bfef7998c1"
  head ":pserver:cvs:@cvs.fefe.de:/cvs", :using => :cvs

  bottle do
    cellar :any_skip_relocation
    sha256 "2424abb2cccd7f41582ea49ccbee60dbecc436c843d9531c0e7c68c35b9330a4" => :catalina
    sha256 "08041ad3f0edd4b20e6ed1f6c768414aa7241940a14386c1dffd04caa5ef70ca" => :mojave
    sha256 "4740574a0e5184f8b371b1a7571304810b4fb29a92d60cf54979387dab3448c5" => :high_sierra
  end

  patch do
    url "https://github.com/mistydemeo/libowfat/commit/278a675a6984e5c202eee9f7e36cda2ae5da658d.patch?full_index=1"
    sha256 "32eab2348f495f483f7cd34ffd7543bd619f312b7094a4b55be9436af89dd341"
  end

  def install
    system "make", "libowfat.a"
    system "make", "install", "prefix=#{prefix}", "MAN3DIR=#{man3}", "INCLUDEDIR=#{include}/libowfat"
  end
end
