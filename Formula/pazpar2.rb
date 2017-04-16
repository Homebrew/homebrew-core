class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.9.tar.gz"
  sha256 "86142e1275546e95395a0b82bfc6d4e5b24b86183ec1a59f843033c1cbdd815d"
  revision 1

  bottle do
    cellar :any
    sha256 "0d9b9ccb9ca70424f7b2e3f55e7a07f840d77debc98b73b7b6302868af5b7d59" => :sierra
    sha256 "8873fe093d90a5e5682921ca8d13aa649f9698e09c132afb6f8d2ff47d9f1d36" => :el_capitan
    sha256 "d8c4913f348ed69eb7d2bb77c44ce1fe99893c7f82f99aec9b6da1485561de27" => :yosemite
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
