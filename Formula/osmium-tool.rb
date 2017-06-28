class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "http://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.6.1.tar.gz"
  sha256 "75523396b3fe51ff585a59251144bd61c93609df0703b7119fe6e16fd4ddb0fa"

  bottle do
    cellar :any
    sha256 "842c6ca8f0756d1e445f525c6e0cc87f7b4610071e4f4eaba657fde765612fc1" => :sierra
    sha256 "292194bdcc7b14c4757e082f9b6078da2900001da4d6ba190734fed529e97981" => :el_capitan
    sha256 "a579e794efd4350c9ec9a53009854da32334f291918560dc2fcac809ff23dafa" => :yosemite
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
