class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1de0a44c29755e29da368537dfe041932140fdbaac3a7e1452006958e490091c"
    sha256 cellar: :any,                 arm64_monterey: "f954229ad517eb90444c024211db05b8b728d422d7d09e34c6aa47f62df81133"
    sha256 cellar: :any,                 arm64_big_sur:  "922579df346fa8302138d14084cbb13392b8f42330200928b71104e6c7a99145"
    sha256 cellar: :any,                 ventura:        "c470f4e445fb5760ab91f577462d2a76497df231b49e56ca05549964b2698cc3"
    sha256 cellar: :any,                 monterey:       "53379506327169055b22ba82838572aa68a7be807ade89dff6f3c7a1762ca458"
    sha256 cellar: :any,                 big_sur:        "4a46c092f50afbba241f1e6eefdb3bab092df96558176618d4f2059bc2a97461"
    sha256 cellar: :any,                 catalina:       "0724f00c4d28966fee1f5fe026d51632c5efab65210462fc50cc05f0daf03a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf885e581d8def9796a668b8f47add7c133313cda9a00f51921c0f47c0d85c2a"
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
