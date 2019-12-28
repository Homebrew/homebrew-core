class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.14.0.tar.gz"
  sha256 "3b0012450c66d6932009ac0decb72436690cc939af33e2ad96c0fec85863d13d"
  revision 1

  bottle do
    cellar :any
    sha256 "4127a49da4e39f24ef5f939c2d8b29d92e8d8ad229e6dfc2f6a9fb78552f59a7" => :catalina
    sha256 "17d57c1b638b7b9e6dc396ccbf43f304bd21d9f3e4fc51d7e2f9b194a97f2e2e" => :mojave
    sha256 "3bb3ad49ad01a78f81ca0b775a71befbd13335c1e589b437e3c7ceecf409497a" => :high_sierra
    sha256 "0974d7cff4b344fe0246736fcc89d94695463d30b7c41893ce23f40d7168c19f" => :sierra
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
