class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.14.0.tar.gz"
  sha256 "3b0012450c66d6932009ac0decb72436690cc939af33e2ad96c0fec85863d13d"
  license "GPL-2.0"
  revision 2

  livecheck do
    url "http://ftp.indexdata.dk/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "6341978a6229069f3078497aa242dfacfb265fdd54c22a8864a516906c83921d" => :catalina
    sha256 "1921d7b34876024b8c0145df01e1c88a385c2851752fb30b2dc918f9ed8ee6d8" => :mojave
    sha256 "bde0d429ddb8f2012ea87a66a0ea1928ef491d414eec5efe231dec219f4d4675" => :high_sierra
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
