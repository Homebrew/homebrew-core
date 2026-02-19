class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "192713eef894735cf2d0dbeed3f8def67c067198e553de01d4a1f14417a64019"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc1baa5dd5df76da0e60f58ab7aeca9dcc6777db4a17e0dfb504bacc257d9244"
    sha256 cellar: :any,                 arm64_sequoia: "e57e2cba4963d12d94581a3a36a4c72da6cb1d525424fcb453b7fd0aaed010a2"
    sha256 cellar: :any,                 arm64_sonoma:  "fc65c6b56db4e2d6c82c11aceede8839433d417cb1e03db37f7ce60c99cc046d"
    sha256 cellar: :any,                 sonoma:        "4ef02a031522ff53efdf941b319ac1f6cc87e03cb2f90f3955c642ab4c594bdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a7b8de027ed75631ab6ed95bf5d49f64ec865f863cf1f52bd036cdd55299b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5df231e42fafe4d7e276c602219adce1c84ac38e536871af96322730caa7f795"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pandoc" => :build
  depends_on "protozero" => :build
  depends_on "boost"
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    protozero = Formula["protozero"].opt_include

    system "cmake", "-S", ".", "-B", "build", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.osm").write <<~XML
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
    XML

    output = shell_output("#{bin}/osmium fileinfo test.osm")
    assert_match(/Compression.+generator=handwritten/m, output)
    system bin/"osmium", "tags-filter", "test.osm", "w/name=line", "-f", "osm"
  end
end
