class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.13.0.tar.gz"
  sha256 "06adfbb0e215ae37bdbf7ddc173ba619359213c893d059e7a2203e91ac877f45"
  revision 1

  bottle do
    cellar :any
    sha256 "d738e111a7d0a3381e3a8dd1df2df61d25590f3d58a21dfdb354a353e18caf71" => :high_sierra
    sha256 "6d70252a58c31a2999130a743f42a15231bf35a7c8ba65cb168e0c58f4bfa361" => :sierra
    sha256 "a0401ae298a53ddd1c33e98b3a0bf5fa0e0f812ac8dd7787b1bf78ff834acdf8" => :el_capitan
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
