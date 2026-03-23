class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "192713eef894735cf2d0dbeed3f8def67c067198e553de01d4a1f14417a64019"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "56aa31ece77621faa6d77d4ca2c477ccfc79c27cc1a7e7103b2a0eb94e0e5e94"
    sha256 cellar: :any,                 arm64_sequoia: "9d870ea12d0d8c312be211d39af65b76e3c8f98c9ae4fce5757be66a105df725"
    sha256 cellar: :any,                 arm64_sonoma:  "6e87840c8c5123626e4e35e70338208033bbe1f3b18a9666581d5c8fae2a0c9a"
    sha256 cellar: :any,                 sonoma:        "ec7db1d7bff5552e5915f0800b6704569e974c0319fd402324ef462e642c2ecb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3510e3c24b08f1e086981e75f4f77116fdb0ca621dcbc46169c1dd35d61b1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62e18c5d574d7ba904a6527b942f5ab00db567e93faf4105c56f8dd7802d4141"
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
