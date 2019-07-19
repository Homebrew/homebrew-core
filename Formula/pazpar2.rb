class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.14.0.tar.gz"
  sha256 "3b0012450c66d6932009ac0decb72436690cc939af33e2ad96c0fec85863d13d"

  bottle do
    cellar :any
    sha256 "bc838735e29c304b4688f0fc8a326573afb6a514437b7cf3d5827a9a12c5f6a5" => :mojave
    sha256 "7015e0a401f3e99e3ffac935e2ae804c35cda64ce2089de501e15ac7490f1d06" => :high_sierra
    sha256 "fc33f784a355e45529b0d47c49157869635a8a7640a8c7c33e88d7ad751f2a82" => :sierra
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
