class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"
  revision 8

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "44eb9c8baaa3da4352d9bffbbc57a4d97023c2f26ac3c82f11791cc43b17012d"
    sha256 cellar: :any,                 arm64_sonoma:  "2aa9e4eb2662d4e016671bd0c1dd0c23f185ff7d98d5b1ad77fe59ae5728a6a6"
    sha256 cellar: :any,                 arm64_ventura: "f30a7a5de7036e177a68214b7f727ead6dbcc832d52389d80d01521b3c636d91"
    sha256 cellar: :any,                 sonoma:        "2c60c0c004da43eb19a4b349a22d6f4da124acefb48238881550625bfbb9a129"
    sha256 cellar: :any,                 ventura:       "489ed1569becf8b4dad09fb19fa0085a40dca876351f8165c404cf6c1ecaabf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50996b95efc667e7e352ec8f13b1e4183b5d425da8779b5e872ac51b096e9ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dc29a2de7c71fb13f0defd9fc5e20d4466a9a74d1d67afb3b1710f52be869bc"
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
