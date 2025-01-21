class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "a7c8e5ee108258a3867c21e80d8bf50ee5b7784c56a12523750d882814e3d6df"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "101bc0c6519988ec87d24ba7197ff8bb65c2346745b4450478b8d3465c20b302"
    sha256 cellar: :any,                 arm64_sonoma:  "fd9cb93ea74208732f720f634ce9a0926cabe2a823ab4c986c6aae9008d66f62"
    sha256 cellar: :any,                 arm64_ventura: "bd7171d46cf4973de8a3731b4ee70220656197e986fe40e1ad936a213e90a43d"
    sha256 cellar: :any,                 sonoma:        "6bf9507be87996fb4547c9a498578abc9855b8723e457e08f24bbd76a2850b9c"
    sha256 cellar: :any,                 ventura:       "646c0077105152279a309b63581789fcbb2893b6345d56ac9d85620085bc6a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7ac2102e5c453bd92a04e7d203172a4c5a48a1606f95ef2fc6df1b7eec83056"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pandoc" => :build
  depends_on "boost"
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"

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
