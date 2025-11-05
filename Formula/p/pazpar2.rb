class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"
  revision 9

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "231f0c8f4214d759fecc1870af5b230ae5f37f1f0ef58ce8f69f847ca69f512f"
    sha256 cellar: :any,                 arm64_sequoia: "163b4b6d4768f37dbc6b33e8c07dec61fc4557d91448820ae57c52f31150ad1f"
    sha256 cellar: :any,                 arm64_sonoma:  "5aec4b1dfb539ff39d55d09a607a9c752b9255b1f9a12a6531e410938ebcf5a3"
    sha256 cellar: :any,                 sonoma:        "59fa9f4f1fc9aac20cfbcec82d9b0c3538931d95b52dbf40678e61ba5d8dda84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b5fcb8c2c9e688fb68a7b3e31bc5e3835b13d80a99446b35e50f414b4aa89ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1786a9f89d196bc588dba5b9a5549fb4044852ae833e72e9eebccbd0e060f117"
  end

  head do
    url "https://github.com/indexdata/pazpar2.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "icu4c@77"
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
