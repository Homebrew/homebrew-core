class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "f98454d9f901be42e0b6751aef40106d734887ee35190c224b174c2f27ef1c0f"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2ed36b05a9c1266e82a46693ac67a4e97ce199d2329f648d7ee794fb2e4ae382"
    sha256 cellar: :any,                 arm64_ventura:  "e13cc5e5df51dcf8f28aed86fe796aae4114bbe30328459c201537a7bc902da3"
    sha256 cellar: :any,                 arm64_monterey: "71ff777114843626e62715e484ec91906dc822437e4aa7c885d15104438b7968"
    sha256 cellar: :any,                 sonoma:         "86ce14cc042d38bb1b93f75a5f8f111d7497af8419903d917ba76179a3eb2d64"
    sha256 cellar: :any,                 ventura:        "d1398d584d0d95acbc558ca91ffce5c19969c75b4b783978848e0fc31dc7a15e"
    sha256 cellar: :any,                 monterey:       "19dd42efee8ea40bad0ffbfa0e95bd51ee68c2d1bd646e70d64630fcfd4faa8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81f444118344e826d8ca115fd95c197698e238952325f0c58fece97f87ef26a9"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "pandoc" => :build
  depends_on "boost"
  depends_on "lz4"

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
