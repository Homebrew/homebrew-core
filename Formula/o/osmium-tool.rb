class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "5438f57043c9df05137ca4bd1b1e4a5fb1c9c8c49cb4bec43a5f1ef30ed68fb5"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "39ab8848b7d3cd170e244d6b41e8c7f367331f25f6cf3fa32f68d64679f9a001"
    sha256 cellar: :any,                 arm64_sequoia: "b886fcf15d6f433f85d93af8b7b5e50d28ab7d65ebf0db6fa25988fad440c248"
    sha256 cellar: :any,                 arm64_sonoma:  "5b609383ae13cdd88a464a02f49edd29eccc95dd1fa7cdb3f1f3eb217e80c259"
    sha256 cellar: :any,                 arm64_ventura: "e91c59db15ddbd9abd1a82d3245e8673e405ee9bb4294a94802bd93785e13dd1"
    sha256 cellar: :any,                 sonoma:        "834c9965363b4920ae4d7ff2b53dafd9a9707cd489a56e5fe0b9212c8407ec24"
    sha256 cellar: :any,                 ventura:       "af40e84b8362633d1e8b37e74b89c61bddac06254ee548fed4d53d535f989043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1d278d2df1034fbdb2e72a6fefa9e6cb7c2fe6e885040782d5179302f167b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9866803a6ed76ff8ea79186e180b44fe9c81d3c8fbc904bbbffe5e32a90cab20"
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
