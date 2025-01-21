class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"
  revision 7

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89b1e41cd5d2e65a1de2f1fe4cbd6ac0a1e73df8fde396660f6dc50f9e50d9c1"
    sha256 cellar: :any,                 arm64_sonoma:  "9b93075658654c4973673e33871b57bddab889d280b5998e361232398f917fa0"
    sha256 cellar: :any,                 arm64_ventura: "2a91e720dfd0c5eb4726c811acb56458a4295f5ff7ed92c51ea9c39c94d14b34"
    sha256 cellar: :any,                 sonoma:        "297db5e1489989de6fb86879857521caf51aaa3ffc891163c99cab33a20cf13d"
    sha256 cellar: :any,                 ventura:       "b4edf2957701a7fb4cff9e309d0d96a703c3c09a98e572739e8ae527650acb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b66983c640e3d06e9e07f7c337ca14506097c790dbdc3f140eb3d614da0218c"
  end

  head do
    url "https://github.com/indexdata/pazpar2.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "icu4c@76"
  depends_on "yaz"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    (testpath/"test-config.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <pazpar2 xmlns="http://www.indexdata.com/pazpar2/1.0">
        <threads number="2"/>
        <server>
          <listen port="8004"/>
        </server>
      </pazpar2>
    XML

    system sbin/"pazpar2", "-t", "-f", testpath/"test-config.xml"
  end
end
