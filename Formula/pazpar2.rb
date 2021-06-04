class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.14.0.tar.gz"
  sha256 "3b0012450c66d6932009ac0decb72436690cc939af33e2ad96c0fec85863d13d"
  license "GPL-2.0"
  revision 4

  livecheck do
    url "http://ftp.indexdata.dk/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0021f3e79b53e697e1cf36eb6b2bd47d84941c9f8318577c1e46aaccb4cee28b"
    sha256 cellar: :any, big_sur:       "d3d553d0d264f72f7da041463b670c52afd453e233434113ff48676874ee4fe8"
    sha256 cellar: :any, catalina:      "e36beb9a3bbc585db1682cca88ff38d5599aa7559a5cbad55bb1ca578be167f1"
    sha256 cellar: :any, mojave:        "48abe4b5d2e20e541a1e9d2a5a96be12e3f886daa354cffcd93220a296a9164a"
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
