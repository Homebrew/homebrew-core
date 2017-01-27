class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "http://research.wand.net.nz/software/libtrace.php"
  url "http://research.wand.net.nz/software/libtrace/libtrace-4.0.0.tar.bz2"
  sha256 "e89ac39808e2bb1e17e031191af8ab7bdbe3d2b0aeca4c6040e6fc8761ec0240"

  bottle do
    sha256 "6447919d8e8463b070e05b6b28c6ff18fb0378dd89cc01b61eba1a6ffd604a27" => :sierra
    sha256 "410e2bc8e025bed1cc3011ad7bbf0b0fbf1e585147fcbb64c237f3cd205fb558" => :el_capitan
    sha256 "3b4b9e487c60283fa6de2def172493fbc5e78a856174ccfd8a2850adcf734dcc" => :yosemite
    sha256 "1ad2c47d6b52a7b40760242f40e40f28730ef3baa26868a1f9300fece0532e0f" => :mavericks
    sha256 "1e1115e10b3c226a49a3c29187327ba39cc5a83941736ed48a5cf866fae3da69" => :mountain_lion
  end

  depends_on "wandio"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
