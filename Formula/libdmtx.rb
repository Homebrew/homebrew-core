class Libdmtx < Formula
  desc "Data Matrix library"
  homepage "https://www.libdmtx.org/"
  url "https://downloads.sourceforge.net/project/libdmtx/libdmtx/0.7.4/libdmtx-0.7.4.tar.bz2"
  sha256 "b62c586ac4fad393024dadcc48da8081b4f7d317aa392f9245c5335f0ee8dd76"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ff67a8026fd8853489878fd980ec7d01a60b5b1bfa74ac45408fcf2ef8580bd8" => :sierra
    sha256 "5517994e8a97229ac3ba665b5a13cb622f6bf09097c84d86cf85c72b1e1f4a37" => :el_capitan
    sha256 "ecb61e93fa9c7698011856693ac7b5335008cbda9807cc5852f0b47dcf1188d8" => :yosemite
    sha256 "c6c2c336211aca2d6fc9c1a71ed4028d99ce2e0f3f50b34e6b916068557c7c18" => :mavericks
    sha256 "86300de879b8d17dbf3f075a5fa1f1d3762c1eebb77e0fdd05ed38f76b75769e" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
