class Libsmf < Formula
  desc "C library for handling SMF ('*.mid') files"
  homepage "https://sourceforge.net/projects/libsmf/"
  url "https://downloads.sourceforge.net/project/libsmf/libsmf/1.3/libsmf-1.3.tar.gz"
  sha256 "d3549f15de94ac8905ad365639ac6a2689cb1b51fdfa02d77fa6640001b18099"

  bottle do
    cellar :any
    rebuild 2
    sha256 "b8c949d8998c9270096abcb32361adf247a3820eaa84c092b029c1d1164e1005" => :mojave
    sha256 "fe3d74c8f7ef3e623e00c7ae3e9bfbba1746047e6334fcc2f46464179f6594e3" => :high_sierra
    sha256 "69c8d53cfacadd06dc4669cb3713028d67333b306e82f36ba1b2d2eae0b9ddb1" => :sierra
    sha256 "c2cd00a63de6490b025d343c349eebda8e4d4545e2669acf116c7d8f84e48dca" => :el_capitan
    sha256 "9b099b33da929eac5c88deadb46136c8e728783793d8a07439de72eb838a61f7" => :yosemite
    sha256 "7dd5682f20fc0aca7994a3d233c0de019f25be9fe4be8c210f24e382c0208a72" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
