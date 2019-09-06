class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://cgit.freedesktop.org/gstreamer/orc/"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.29.tar.xz"
  sha256 "4f8901f9144b5ec17dffdb33548b5f4c7f8049b0d1023be3462cdd64ec5a3ab2"

  bottle do
    cellar :any
    sha256 "d2f7fdd730740d23c0a3da22b3fac412b68974a0e6c4cc1f5b55abf8f075d374" => :mojave
    sha256 "a04f6a05f82c5dc8ba526992d294fccb9d3e1206fd21e9e870f04f226f88f86e" => :high_sierra
    sha256 "9a84e0cc0f7268c805ab3440302e40f5b4c44f48f47b284e23c75f1e7014c206" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make", "install"
  end

  test do
    system "#{bin}/orcc", "--version"
  end
end
