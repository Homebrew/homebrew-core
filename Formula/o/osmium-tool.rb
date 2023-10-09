class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.16.0.tar.gz"
  sha256 "f98454d9f901be42e0b6751aef40106d734887ee35190c224b174c2f27ef1c0f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "95ebcb7d3b5a0cf22d422468f23c894a4ec9902e638b0dcc170515a6f28cc53c"
    sha256 cellar: :any,                 arm64_ventura:  "6ed20085ddcadb8f0e5fe7999361ee4c05e15f27135d58216e2b8ccc3445d385"
    sha256 cellar: :any,                 arm64_monterey: "f96842d0ddbd0ebc7aface97569adaed09f82e725bf019d1cece927a1c9bd188"
    sha256 cellar: :any,                 arm64_big_sur:  "afc0eb11e5248389f5b5f8a8cf7adab899b033f84f94e60f97d2ec8aa8ca1a6b"
    sha256 cellar: :any,                 sonoma:         "6e0977de14cc0672e42b2bc63fa4593f76c011edac39f8f46ebbf60eb8b265d0"
    sha256 cellar: :any,                 ventura:        "b45cdaca24db13c5150d7abb1d5a47f16ae5a02e3f091e14660a2153702e8fd1"
    sha256 cellar: :any,                 monterey:       "b848130312527ea781cbecabb8089611ea0c672f13a0ab8f9e1bb1d464562d48"
    sha256 cellar: :any,                 big_sur:        "4b0829bd58fb611d0e7e4a928b29379ada6a72f3d832b181c88c43e7a04c52bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa14b99e94a4e37231b2aaa7dea65f6d831641c322e16bed401a91b7d055d288"
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
