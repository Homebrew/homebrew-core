class Cronolog < Formula
  desc "Web log rotation"
  homepage "https://web.archive.org/web/20140209202032/cronolog.org/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/cronolog/cronolog-1.6.2.tar.gz"
  mirror "https://fossies.org/linux/www/old/cronolog-1.6.2.tar.gz"
  sha256 "65e91607643e5aa5b336f17636fa474eb6669acc89288e72feb2f54a27edb88e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c99140b690aae4c8e28b53ba787ed5aef53d3fbc867186aca47cab021068db40" => :mojave
    sha256 "47a40bdccb74cb45e3df9e73306162ecc7206c26760521c6a9d8760872769b6b" => :high_sierra
    sha256 "66ad5bfa0080775875d2b72cc2bbd66bc8ee8de7ca1d482217414ba5b805f977" => :sierra
    sha256 "964df15660a5c0ec25bedec56aeb128ae93794a8ad721c1c600e377df9be1c2d" => :el_capitan
    sha256 "f3f485105f7466422a507bafef3acfd741f18b8ab26438c267d10dbf4701282e" => :yosemite
    sha256 "288bcd1671de08659b7d2f67141aa5178d797870597837c569dccfaae460afd8" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end
end
