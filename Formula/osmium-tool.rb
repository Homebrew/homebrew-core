class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.11.1.tar.gz"
  sha256 "ea47ca909d167951b975673b8a818600f988aeb35a5a911d4a3a0004bc76f04a"

  bottle do
    cellar :any
    sha256 "3a94cc46c4eded84287fee50fed5582f93ce29f158286018b322f9f98dc1a25f" => :catalina
    sha256 "6c9706f35cafe0e4ca47f4001ef2a79464f012d2b067fca3e1f63a9624d576c8" => :mojave
    sha256 "beda680852c644ddda11b7f4f13290efbc28630f36260a77bf1027c9e447345a" => :high_sierra
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
