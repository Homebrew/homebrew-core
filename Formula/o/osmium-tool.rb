class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "e629d2f3e500ffa5df6f1b1689161ab3dea3a82f66beec2b453a74b8d782f949"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bbd3f3446f65fb406c0b9edabc4824610e8a74cd1c92671004a3be8346c0c996"
    sha256 cellar: :any, arm64_sequoia: "37ee8165ca3d08b499c78c2c97d84ba40afed80579e4123d98e17b6ed85cb0cc"
    sha256 cellar: :any, arm64_sonoma:  "44b9c87c5cf30be97252b7464d8ba51eab9e09af76f9bf2b71ff9ed2d65eac7c"
    sha256 cellar: :any, sonoma:        "6beeee89716a3d736da4b43b13e39f0e572dc12a33e5938b9352cde7a0cb1b66"
    sha256 cellar: :any, arm64_linux:   "91f3e6aa24473cc30859302a18d56dcfc46e42bdfc4893952f3fd7270ac4d9d0"
    sha256 cellar: :any, x86_64_linux:  "c84b3f5aa9b8252701fde4f56a7aeb727466e185ca0c3f326e7509abbb102062"
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
    protozero = formula_opt_include("protozero")

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
