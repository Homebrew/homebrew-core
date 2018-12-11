class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.10.0.tar.gz"
  sha256 "f0a75ce39ac92c43a01d978c1ecae05d864930bf7d518ea059d7ba320735dd66"

  bottle do
    cellar :any
    sha256 "734f624dafc9b6f53742bf0997c21bd37cc2cdba9bb7859d8f3739e622747f5e" => :mojave
    sha256 "e2e09db5a71531ec54f8df660168b8ea681b02d933e9a7258bab6e1f71983ae4" => :high_sierra
    sha256 "3bfc4c2b838182c1eae0fb0c4ecbe5a05b5f1a9382603b390041c73c2499eccc" => :sierra
    sha256 "bfdd6374100a7b2615a7dd6d004041a480522f93bbac7ed794be16658d814a87" => :el_capitan
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
