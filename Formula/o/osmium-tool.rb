class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "e629d2f3e500ffa5df6f1b1689161ab3dea3a82f66beec2b453a74b8d782f949"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "150ed6e50922b14f1c9ae961178838a095d7c6f85431b0290a59c06729788d79"
    sha256 cellar: :any,                 arm64_sequoia: "1e7ab6669b6660c6870d4af9a7f047135cb2fff8aabc40a2305eaec16d6d819b"
    sha256 cellar: :any,                 arm64_sonoma:  "c9ee74497fe1729afa04c0912793d37f6aee76c8f3a8c6ef6592c365fb06e1e3"
    sha256 cellar: :any,                 sonoma:        "addbb0da5c3cb86ee2c080829dff7832688a99cffa71194c72ea0a7e69e79f23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "901af55b90a8b55d2010aaeb6901128361f6999bdfe5dd4e27438c835a329098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f83163be3e38b634c93b6d3c906d62f8cb5ee1d7a711c8c09ce6896f8def5bf6"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
