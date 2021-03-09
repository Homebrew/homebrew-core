class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.14.0.tar.gz"
  sha256 "3b0012450c66d6932009ac0decb72436690cc939af33e2ad96c0fec85863d13d"
  license "GPL-2.0"
  revision 3

  livecheck do
    url "http://ftp.indexdata.dk/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "60db540ce6032e173dad803d41cb870309b6459f7e61ee051305be90100df997"
    sha256 cellar: :any, big_sur:       "a03f03e415910f4a4d2f0a69d1c132ad41c09581f9986f828f370a013169d05d"
    sha256 cellar: :any, catalina:      "61a154c49f39f4b85c9e6a90b26f7240bf1345d04982bfd7a6b8d7fca47ae5a6"
    sha256 cellar: :any, mojave:        "12269d35c8cc99cef098c71cb7d19ea42f594619915eff41dd3a0b5f43613f91"
  end

  head do
    url "https://github.com/indexdata/pazpar2.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "yaz"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test-config.xml").write <<~EOS
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
