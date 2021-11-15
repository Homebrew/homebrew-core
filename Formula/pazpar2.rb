class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "78416003bce41475a204ac9c6790ddc3d54b447420df819bf435d584a2732643"
    sha256 cellar: :any, arm64_big_sur:  "97853be3b6575960315829c3d405783d807ce3ef2e02a1be58a99f15940242a7"
    sha256 cellar: :any, monterey:       "ebf7437098ce671bdea94f57a994fad64dc857480d1230451240120a336fb669"
    sha256 cellar: :any, big_sur:        "f0f875a02f27f621b8d3853067f2de93e81f14bd5d39410a8a5fd16bd77fed72"
    sha256 cellar: :any, catalina:       "3dc830947f389049e4960f548f407cf1d867bd13822038e1580d864faebd5cde"
    sha256 cellar: :any, mojave:         "4ae1cdd71740cfad4d06799ebc4b131dd705fea1411c9fd85aacaf49ff63d66c"
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
