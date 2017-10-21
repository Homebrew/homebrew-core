class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "http://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.7.1.tar.gz"
  sha256 "5cdb01ca22bfc0cfd2b1a59088601f61547d60ffa47296087480718ff0156c42"
  revision 1

  bottle do
    cellar :any
    sha256 "398b88bc8316244cefe4d9dcec282493d6b37f56b19297e149367443e58062ed" => :high_sierra
    sha256 "05dce7612f933019fe5a2a55e7fa3746c1ecc83282d1dde5ff3f63d3e349a677" => :sierra
    sha256 "11203e8a401505daaa5173adeac65d5a6132859855d50798b669f748764fa0dd" => :el_capitan
    sha256 "bd7b60b6c69a008721904db31b5362bb687d147dc713af3d5749d9fe5226d95a" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
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
    assert_match /Compression.+generator=handwritten/m, output
    system bin/"osmium", "tags-filter", "test.osm", "w/name=line", "-f", "osm"
  end
end
