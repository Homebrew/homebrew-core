class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.13.0.tar.gz"
  sha256 "06adfbb0e215ae37bdbf7ddc173ba619359213c893d059e7a2203e91ac877f45"
  revision 2

  bottle do
    cellar :any
    sha256 "b2740e5f06aa0d25fc91b336a0cc000eacdbdbaae19d9f9a49bfd551182da8fe" => :high_sierra
    sha256 "dada3e42b697e83a96aa6cdbe2aacad8774dde262ada11905e14a99cdfb19c14" => :sierra
    sha256 "0bd5abbbb2903b793a178dabc517604acf36a532095fd6beae2cbf0f3c376fe8" => :el_capitan
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
