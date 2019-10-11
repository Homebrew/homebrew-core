class Ipsumdump < Formula
  desc "Summarizes TCP/IP dump files into a self-describing ASCII format"
  homepage "https://read.seas.harvard.edu/~kohler/ipsumdump/"
  url "https://read.seas.harvard.edu/~kohler/ipsumdump/ipsumdump-1.86.tar.gz"
  sha256 "e114cd01b04238b42cd1d0dc6cfb8086a6b0a50672a866f3d0d1888d565e3b9c"
  head "https://github.com/kohler/ipsumdump.git"

  bottle do
    sha256 "bf3d17d0d8bd97b75c44fd7929e348e096f3f1ac6a94ff31e785eb1f685db041" => :catalina
    sha256 "1ca321c3b11654d07e0f2f6a13e6e36ccc28b550a42515cd495777f15f1e05e9" => :mojave
    sha256 "16c995a9158257d8390cda7223f4d0620b6189c331177336b81f81077ee81620" => :high_sierra
    sha256 "96148641aa0430d8b80cb3ebad8994d1911d61cad9557155172490579e210eaf" => :sierra
    sha256 "a98b6116340b9b459f53310c030e99b8022f546c78cda7fcb040ea87c6e2a5f6" => :el_capitan
    sha256 "83b145e153aa8e0680e9329035fb9ad55ce8875a2a6c8d35879821f51e394c7e" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ipsumdump", "-c", "-r", test_fixtures("test.pcap").to_s
  end
end
