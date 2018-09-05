class Binkd < Formula
  desc "TCP/IP FTN Mailer"
  homepage "http://binkd.grumbler.org/"
  url "https://happy.kiev.ua/pub/fidosoft/mailer/binkd/binkd-1.0.4.tar.gz"
  sha256 "917e45c379bbd1a140d1fe43179a591f1b2ec4004b236d6e0c4680be8f1a0dc0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1582b44b77979d7258c51baec8bb54f367fc21f8cc03838c9c1b1351ea9f77e7" => :mojave
    sha256 "e890bed8ae5c89dfabd589e2c9654b2c8da6811bd24fbfd99aa4fc520a535e26" => :high_sierra
    sha256 "d685be9cb23ecb98dc34c2ea185c47ec39e54db1a8ca88782d11cbd96c78862a" => :sierra
    sha256 "d69c67a3cb68789a0a96196b5d2d92e44e6dd9bab3eb870ec9727987ae538c35" => :el_capitan
    sha256 "e56862a339a1de58072d3ffb23981bff13a1eb69322c5e12e47949c171d5ceff" => :yosemite
    sha256 "55690b37076bc21a7764f85ff97957bc0403b4b45ed6b12585c800d72785bfdb" => :mavericks
  end

  def install
    cp Dir["mkfls/unix/*"].select { |f| File.file? f }, "."
    inreplace "binkd.conf", "/var/", "#{var}/"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{sbin}/binkd", "-v"
  end
end
