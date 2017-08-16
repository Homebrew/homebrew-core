class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "http://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.7.0.tar.gz"
  sha256 "344f9f2aa6b34807a7724e9443bfa7f716745bf132facdc0f440d0d57c2533e0"

  bottle do
    cellar :any
    sha256 "49b71d3333ab369aaebeff89105c79559e7bd3c743c5213ab7a0e04bc82b1787" => :sierra
    sha256 "1994ded450727df891726f316421d6f8956e0f757678446fea16ca76d7d0a9bb" => :el_capitan
    sha256 "b7949426174e8f4b18a15412bb588b9a698af0065e0e1d0e4e78752d2d02f171" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.osm").write <<-EOS.undent
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
    assert_match /Compression.+generator=handwritten/m, output
    system bin/"osmium", "tags-filter", "test.osm", "w/name=line", "-f", "osm"
  end
end
