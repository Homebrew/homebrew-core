class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.11.0.tar.gz"
  sha256 "09720d8ffcf250000628cb174934885962e09677094bd5bd96071f11fe170f4f"

  bottle do
    cellar :any
    sha256 "6f14fde0e76d89262255088702c169ba5365f1cc7104e593f7c2dc637615444d" => :catalina
    sha256 "0cb1db38af7428122b6c20020bceef2b317502a9b6b8bfc3a3f43573877c6607" => :mojave
    sha256 "2907f2104422926f05310bfe120e4c15e796d037c698079afb32fad2fc6a66ad" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "boost"

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
    assert_match /Compression.+generator=handwritten/m, output
    system bin/"osmium", "tags-filter", "test.osm", "w/name=line", "-f", "osm"
  end
end
