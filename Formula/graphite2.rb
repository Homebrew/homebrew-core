class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "http://graphite.sil.org"
  revision 1

  head "https://github.com/silnrsi/graphite.git"

  stable do
    url "https://github.com/silnrsi/graphite/archive/1.3.9.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/graphite2/graphite2_1.3.9.orig.tar.gz"
    sha256 "f82f92d86a63da79eba10a37c80d943dce883bd72dbc99ebe5bdb7022d3e2391"

    # Patch for CVE-2017-5436.
    # https://www.vuxml.org/freebsd/cf133acc-82e7-4755-a66a-5ddf90dacbe6.html
    patch do
      url "https://github.com/silnrsi/graphite/commit/1ce331d5548b.patch"
      sha256 "39613db98f959b48adc2387d37a5f384566172b906d949edad452fcd48c3874c"
    end
  end

  bottle do
    cellar :any
    sha256 "cae141f3980ef8bbac6953e3fb1807a460dd80de277e15043289f4598f389005" => :sierra
    sha256 "2b5cbbc83d06e1bc75985eea0e27f5d569e381c30b3a579dc3c05aebf50b210a" => :el_capitan
    sha256 "a483f552d39ed4d3dbfb3abb73301fe273b81fb4842c67b294f96dc25f353ac2" => :yosemite
  end

  depends_on "cmake" => :build

  resource "testfont" do
    url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
    sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
  end

  def install
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    resource("testfont").stage do
      shape = shell_output("#{bin}/gr2fonttest Simple-Graphite-Font.ttf 'abcde'")
      assert_match(/67.*36.*37.*38.*71/m, shape)
    end
  end
end
