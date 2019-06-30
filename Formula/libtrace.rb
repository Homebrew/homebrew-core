class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https://research.wand.net.nz/software/libtrace.php"
  url "https://research.wand.net.nz/software/libtrace/libtrace-4.0.7.tar.bz2"
  sha256 "bb193db90898b88fa6fc05ac1a99d377512ab61b4ab0567adcd7bbab52e0224f"

  bottle do
    cellar :any
    sha256 "0abb634372aa245707f2cc1150ebf580005fa5b96b43655cf450c002dcaa1015" => :mojave
    sha256 "ccb85ce4c5f01975fb0cc208f4433b30d8c296011e29eddef69c3f7d26e0f659" => :high_sierra
    sha256 "c7cb15f1960f6a682765fd5abd130ad528517ae66e1af015662786643751bb91" => :sierra
  end

  depends_on "openssl"
  depends_on "wandio"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
