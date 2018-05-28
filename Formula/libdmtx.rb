class Libdmtx < Formula
  desc "Data Matrix library"
  homepage "https://libdmtx.sourceforge.io"
  url "https://github.com/dmtx/libdmtx/archive/v0.7.5.tar.gz"
  sha256 "be0c5275695a732a5f434ded1fcc232aa63b1a6015c00044fe87f3a689b75f2e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4385284c846997c65dfcce5911ac0fe5b3229c9b877497fcaab6d738ae5f3132" => :high_sierra
    sha256 "ff67a8026fd8853489878fd980ec7d01a60b5b1bfa74ac45408fcf2ef8580bd8" => :sierra
    sha256 "5517994e8a97229ac3ba665b5a13cb622f6bf09097c84d86cf85c72b1e1f4a37" => :el_capitan
    sha256 "ecb61e93fa9c7698011856693ac7b5335008cbda9807cc5852f0b47dcf1188d8" => :yosemite
    sha256 "c6c2c336211aca2d6fc9c1a71ed4028d99ce2e0f3f50b34e6b916068557c7c18" => :mavericks
    sha256 "86300de879b8d17dbf3f075a5fa1f1d3762c1eebb77e0fdd05ed38f76b75769e" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
