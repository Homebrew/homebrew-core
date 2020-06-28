class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.12.1.tar.gz"
  sha256 "c8945b2b85fda7898faaf97b57faf759a06a4cf6a2c591f857779dcc503f32f2"

  bottle do
    cellar :any
    sha256 "1db62b797769c87d7d004f9b2930086597ebc122c141817fa23395f74f0bf831" => :catalina
    sha256 "c1d8c1ac8cca189e1bce3348f1e82b5098c713643735891b48b2268b01b90d3c" => :mojave
    sha256 "bd3909430695b6d46bc6aad69396dba01674f539de14e56c943a2b45cb6fa125" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "boost"

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
    assert_match /Compression.+generator=handwritten/m, output
    system bin/"osmium", "tags-filter", "test.osm", "w/name=line", "-f", "osm"
  end
end
