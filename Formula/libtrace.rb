class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https://research.wand.net.nz/software/libtrace.php"
  url "https://research.wand.net.nz/software/libtrace/libtrace-4.0.7.tar.bz2"
  sha256 "bb193db90898b88fa6fc05ac1a99d377512ab61b4ab0567adcd7bbab52e0224f"

  bottle do
    cellar :any
    sha256 "094a254fb297ef4af3a6c14e2f5812e1a50702ebcd5be0813d87c4d252c5f0aa" => :mojave
    sha256 "f0277f98c7050a9e99dad5ddcb412c61d2b224d8cda2e4e891cd38faad78d05c" => :high_sierra
    sha256 "92639a1fab6d9622b2692bb5b7b5d336605e3e541307f80e08a887750e7ab368" => :sierra
  end

  depends_on "openssl"
  depends_on "wandio"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
