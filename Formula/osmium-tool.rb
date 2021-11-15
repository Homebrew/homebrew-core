class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.13.2.tar.gz"
  sha256 "a6516087bfe1f6c881c9087b448ee8965b7d1730e29e4e8e982cd2ef8c4f8d98"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a1e85864e81239d90e4e0592fcd1fe7eab4118d06f34e4b6ea4560fb9ec66294"
    sha256 cellar: :any, arm64_big_sur:  "bb643b8ff8b55a149f0fb6b57c1abd347fdca943a6a8d44baf34cc123bf47b9a"
    sha256 cellar: :any, monterey:       "ae1f3ea8a20597ec99ba4e43d46de8d45c0416dac1fed9464e111a5e6c1d307a"
    sha256 cellar: :any, big_sur:        "589eb5fd205fe081a5fa470f44628a186c1ac0c9d6546d7aa02308ad32bd83f8"
    sha256 cellar: :any, catalina:       "3c8ed5d3feb01942592c9ecbc6e32e5be0fbcce61411e75c7240f0d2d6ff2446"
    sha256 cellar: :any, mojave:         "0c1d2dcf31540f5a0218d9413dc7b990d3dd9e21d5d261a3ff617365cec6d0ed"
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
    assert_match(/Compression.+generator=handwritten/m, output)
    system bin/"osmium", "tags-filter", "test.osm", "w/name=line", "-f", "osm"
  end
end
