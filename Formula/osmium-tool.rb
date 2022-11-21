class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.14.0.tar.gz"
  sha256 "67765fe6b612e791aab276af601dd12410b70486946e983753f6b0442f915233"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ecfb1b350bb2d92d32ff311a1659084db2000b244eb7351c30bf94283c35265a"
    sha256 cellar: :any,                 arm64_big_sur:  "cfb56102bd3cb066cdfade5936679d4cf1c5ff7cb36464f901b7cb2071873aab"
    sha256 cellar: :any,                 ventura:        "fee70d13913c52c1cb502f5150586c15d88228c1459edb566999f1687d816f5b"
    sha256 cellar: :any,                 monterey:       "2e11f60463925a700b88a2b171905a8a8f64ee2cd7cfb44965a7d61ac4f7a8ef"
    sha256 cellar: :any,                 big_sur:        "457422771493c4c8d432f7081c77d806113886da9dcaacf60f3c2c1465948acb"
    sha256 cellar: :any,                 catalina:       "8f25a3775f55b6c72cca6714632ed5463b94a724ea619a8955c4fc94dc03ff38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a0c1361abc5a4d59d50e84438072f7903428a55372029578bdcd01cf068fee9"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "pandoc" => :build
  depends_on "boost"
  depends_on "lz4"

  uses_from_macos "expat"

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.osm").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6" generator="handwritten">
        <node id="1" lat="0.001" lon="0.001" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <node id="2" lat="0.002" lon="0.002" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <way id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <nd ref="1"/>
          <nd ref="2"/>
          <tag k="name" v="line"/>
        </way>
        <relation id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <member type="node" ref="1" role=""/>
          <member type="way" ref="1" role=""/>
        </relation>
      </osm>
    EOS
    output = shell_output("#{bin}/osmium fileinfo test.osm")
    assert_match(/Compression.+generator=handwritten/m, output)
    system bin/"osmium", "tags-filter", "test.osm", "w/name=line", "-f", "osm"
  end
end
