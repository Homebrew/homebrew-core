class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"
  revision 5

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0f5b9eda587cc7108478df960e74800ce079e09bc131199b24cc37c6ed2ed0aa"
    sha256 cellar: :any,                 arm64_ventura:  "19fe5a070389f82d87c36335ac4b123d8c72cff599e973acda4adb6e7be0384f"
    sha256 cellar: :any,                 arm64_monterey: "c849fb96b762c184451e288ccde1514420e2b8071856d000e5b0a4ba5176a278"
    sha256 cellar: :any,                 sonoma:         "7da68c0e0be9587afa65f166f41e20d6e6e6dcfc1d0fa55443c747ca867e4f03"
    sha256 cellar: :any,                 ventura:        "5ec6a7c0bd7bb41976b42b3514b5c66f58e0021a027ac7136fbc3d2e942d6055"
    sha256 cellar: :any,                 monterey:       "e0d0e10a9d903782753abe567aa3610a310276f2f4ce0a1332c02e0b22e5cfa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3122dee93d74f767ca110f6ca80763c78c4fa9d376892b08fdbe3e27f98d0cce"
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

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
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
