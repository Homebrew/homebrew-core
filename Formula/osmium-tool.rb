class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "http://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.7.1.tar.gz"
  sha256 "5cdb01ca22bfc0cfd2b1a59088601f61547d60ffa47296087480718ff0156c42"

  bottle do
    cellar :any
    sha256 "5e5529cc807ed81151195eec2a31ba37aa168a02d96217bea33ac703901d4832" => :sierra
    sha256 "824abf61d26ca3a7fe47a914167fe1b0548adfbfd26155a0e8c6a897dc7810f2" => :yosemite
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
