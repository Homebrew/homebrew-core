class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "78bcd6eaa3b662f92110bc0b9d45d585ec8bdbde67b4dc4a2b405c7d6e58c94c"
    sha256 cellar: :any,                 arm64_monterey: "cc840568464e25c0661076ee56ea8230ba3d6c4550010c18109e123834f8118f"
    sha256 cellar: :any,                 arm64_big_sur:  "8097ef633c2e3489f322640e7043fa3dbba14a08e3065a15bbdd1879052981aa"
    sha256 cellar: :any,                 ventura:        "1bbbf5ab7ddcb22ebad5ac5a009cea761cb9de0443731ff7f49f956154c401d7"
    sha256 cellar: :any,                 monterey:       "addf5e45be0b6667882a93f57a9149a7afdfa746bf484bdbee1a0a14579956bd"
    sha256 cellar: :any,                 big_sur:        "3e16249082fd4fd0a3d46348de7b1e4b3b8bcac48c3eb4102b80875783aee2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b2d098a7ab8bc0571da0f1908afce25da7f5c190d8b9921df8f61c2b1b2ef1c"
  end

  head do
    url "https://github.com/indexdata/pazpar2.git", branch: "master"
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
