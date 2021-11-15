class Ipsumdump < Formula
  desc "Summarizes TCP/IP dump files into a self-describing ASCII format"
  homepage "https://read.seas.harvard.edu/~kohler/ipsumdump/"
  url "https://read.seas.harvard.edu/~kohler/ipsumdump/ipsumdump-1.86.tar.gz"
  sha256 "e114cd01b04238b42cd1d0dc6cfb8086a6b0a50672a866f3d0d1888d565e3b9c"
  license "MIT"
  head "https://github.com/kohler/ipsumdump.git"

  bottle do
    sha256 arm64_monterey: "1494705fff0bb7937d74557efd7484896a8c87133dad9a4e40ee2ee5b5da67eb"
    sha256 arm64_big_sur:  "6348649ec33f562a3622f97fb7b253d39ed8b3f919a9aa2af8fa84b8d67d765a"
    sha256 monterey:       "421b6575ab2ea358e7dadb1d43f2519efb2e8f8353260c3e2b83e7d4610d3841"
    sha256 big_sur:        "f3302bce45a3eed980b7c07d05eabc9088a469cd07528c5e1f32a52474b6383a"
    sha256 catalina:       "bf3d17d0d8bd97b75c44fd7929e348e096f3f1ac6a94ff31e785eb1f685db041"
    sha256 mojave:         "1ca321c3b11654d07e0f2f6a13e6e36ccc28b550a42515cd495777f15f1e05e9"
    sha256 high_sierra:    "16c995a9158257d8390cda7223f4d0620b6189c331177336b81f81077ee81620"
    sha256 sierra:         "96148641aa0430d8b80cb3ebad8994d1911d61cad9557155172490579e210eaf"
    sha256 el_capitan:     "a98b6116340b9b459f53310c030e99b8022f546c78cda7fcb040ea87c6e2a5f6"
    sha256 yosemite:       "83b145e153aa8e0680e9329035fb9ad55ce8875a2a6c8d35879821f51e394c7e"
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
