class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3aa56446afff401c334ab750e18eb49161bdbc576abed93c8b604f2466c65043"
    sha256 cellar: :any,                 arm64_big_sur:  "10a49c1be55e77d741cb5e5a78037fe123fafd371087bca63114ce3622f662aa"
    sha256 cellar: :any,                 monterey:       "eaa9630b359a5e829528011599c7f3aeda1464562b13cb5258c461ce11d8657e"
    sha256 cellar: :any,                 big_sur:        "4ccab6ab3e93d2e41fd19053aa14bf3cfa79016be44c42203a81098cb92e42b2"
    sha256 cellar: :any,                 catalina:       "ef08edbcc9fa2d979dbd31fbe8ee32f296fd0b4d29d2091f0b0cf3b39f8f25e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e0de42993b51c92330d1556e2e5b3e8cbdc805f561ebd6333b58d6d72feef47"
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
