class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.13.tar.gz"
  sha256 "02a97773ba27a2481744fc2323a9488a64661f7d1da09e5e61443c9b6a10cbed"

  bottle do
    cellar :any
    sha256 "ae70a824d58f570b04cacd3983548daec016e57419c0fb7507bbd6f377279c5b" => :high_sierra
    sha256 "115705b05a9b482e873c3d1b2826adb1e6efdc4b8c05ab932b569e78e0e778ab" => :sierra
    sha256 "88f4bcb2934900e5c7349bbc921f87d9b6b932ec03d133b49240571f9fafa569" => :el_capitan
    sha256 "1c12e0fc57357f65b3931d90172732c4375ee973e35987638174fd661ecbf719" => :yosemite
  end

  head do
    url "https://github.com/indexdata/pazpar2.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "yaz"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test-config.xml").write <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <pazpar2 xmlns="http://www.indexdata.com/pazpar2/1.0">
      <threads number="2"/>
      <server>
        <listen port="8004"/>
      </server>
    </pazpar2>
    EOS

    system "#{sbin}/pazpar2", "-t", "-f", "#{testpath}/test-config.xml"
  end
end
