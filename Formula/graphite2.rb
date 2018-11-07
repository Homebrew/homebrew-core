class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://graphite.sil.org/"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.12/graphite2-1.3.12.tgz"
  sha256 "cd9530c16955c181149f9af1f13743643771cb920c75a04c95c77c871a2029d0"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    sha256 "152674570814598d46c8dd2462319e3f95f14c605a6509c0f37b436a9f72c307" => :mojave
    sha256 "bc6822fcaec5128f42706dc99ddf4e7565b4b2dc08d5ecb72757991b3fc94dca" => :high_sierra
    sha256 "7f80d1268cae3d36d362045a08fbb1454cb7249506bce905853204ea401424b0" => :sierra
    sha256 "d6203a6e9563431e67f0a7579e0a94af962c48b0738656459a86277289e9d251" => :el_capitan
  end

  depends_on "cmake" => :build

  resource "testfont" do
    url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
    sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
  end

  needs :cxx11

  def install
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    resource("testfont").stage do
      shape = shell_output("#{bin}/gr2fonttest Simple-Graphite-Font.ttf 'abcde'")
      assert_match /67.*36.*37.*38.*71/m, shape
    end
  end
end
