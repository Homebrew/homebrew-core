class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.13.0.tar.gz"
  sha256 "5f955080d6f07a369570bd93eaa0cf9a9bbaa9536fc931ce7c1feed60a8bb413"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "0a99d19a3918cfd60242b61104b75a36652d878d4c66f61603199c20d12ef1d8" => :big_sur
    sha256 "5bc39388890c18e37d0fa87b1644a7f3768860721980ac324fe5737d411eefca" => :catalina
    sha256 "67e2e3075ab367207375d3d84dcd4c5cd014757fcae8213787cf45b3a2e262d0" => :mojave
    sha256 "b892d8dabfb211da58b6a3e2ffa6a5a65c2d5f8ceb481979fa14667be4a1ba62" => :high_sierra
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
