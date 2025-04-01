class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "5438f57043c9df05137ca4bd1b1e4a5fb1c9c8c49cb4bec43a5f1ef30ed68fb5"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dee9a76f1c9ba7b231c42a5f565c77e7e24b02ca5b6c8eff21f0045231011ec6"
    sha256 cellar: :any,                 arm64_sonoma:  "583163fcd84f74cbbd5dd3884dc2ee46e97d531710f6e35e691e7803e6cf73ed"
    sha256 cellar: :any,                 arm64_ventura: "a2d21fcc118f03e866c9bd7e2a43cb052fad51ed27f0573b565707e71b6a8c00"
    sha256 cellar: :any,                 sonoma:        "fd7e9601f040612eda9e745b187469bd7d4f4fceea3acc92543045f331cdb71b"
    sha256 cellar: :any,                 ventura:       "47e5cf6a115a3f64d6da0d339ab83bdcc33b6e17d0528174a512fdef8f830ef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34dbce2276a3c0273ac6b610c9e5c5840c953e414bc7e0e486b4bfe651dbd13"
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
