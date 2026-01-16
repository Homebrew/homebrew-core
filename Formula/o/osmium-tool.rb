class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "5438f57043c9df05137ca4bd1b1e4a5fb1c9c8c49cb4bec43a5f1ef30ed68fb5"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9628b5bb2ded899a0b418e46dd80aa57e49b03ed8a0731efc9a3d2ceae6625c5"
    sha256 cellar: :any,                 arm64_sequoia: "e74f0554ad833680a84c2c282449310987319ba52c636a8fa708fc6e12f8775b"
    sha256 cellar: :any,                 arm64_sonoma:  "af46c190895a353b1976d8baf3152c5caaea90e3773c0bb6a205aaa8a9c820dc"
    sha256 cellar: :any,                 sonoma:        "cd2766f4778e03b4047d3daa8b1fc38adb1517ac6f0ca65352accc236f7a2127"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fabe88144b92310d9b99e689e39a722a8a45a5eb4835376d1713391a5c7f69f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdf9503490509be6381708d39b012b6a6f4142f84aa724f86190c6c0d1d2c4df"
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
