class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "162654ec2c087897997249feccbf3595e456bdad51b6140b5a3fa6134ff484ad"
    sha256 cellar: :any,                 arm64_monterey: "0f14b91888d588aad368bf8611b603f141db2834e361b842d490aa6d5ee156e5"
    sha256 cellar: :any,                 arm64_big_sur:  "78304e1b4666d5db378d16a3b6c0915c77271e919208baa149532fa2ab9be197"
    sha256 cellar: :any,                 ventura:        "1335d7c65c598cd0535767853aaecbc93c741901e133fae9d4e0c91517d0180b"
    sha256 cellar: :any,                 monterey:       "c76b9a7e741031283bf83a96d5c051016fdaf19bb3b5854842d1dd3e8ac56b80"
    sha256 cellar: :any,                 big_sur:        "fce42a0b3e170d057b9a6b8602a7bfd91570ff9bfaf825b3e547a0b5b27075fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "822af8eb36975de56c5802a76d1e2f947ff964be6f1c7b7e6077968f0701320c"
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
