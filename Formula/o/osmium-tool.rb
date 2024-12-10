class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "f98454d9f901be42e0b6751aef40106d734887ee35190c224b174c2f27ef1c0f"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ebda02a23a3f1cfa0275f71e2c5445e5f3127bc3597db4b16e1fa4b9972500de"
    sha256 cellar: :any,                 arm64_sonoma:   "f8c2f5614625cafdf9e42a325d1565e25281f9cab2f89ddbc717a05f6a768fff"
    sha256 cellar: :any,                 arm64_ventura:  "189ab4022fc116085d637ccd93ea248972a9873b5b37d6df3e26c417aee5cbef"
    sha256 cellar: :any,                 arm64_monterey: "1a168fb4ababa8829f1720b5759ffe48e620d93ebd82b713e6070bcad5e08274"
    sha256 cellar: :any,                 sonoma:         "4f3cb5053fa0d24861c5fccfdcc15b010c07af138cb6ff2b9d49d9f3b9753185"
    sha256 cellar: :any,                 ventura:        "6921c1baafe13854f684136de7cbf3ca0e7122291e3e66588464230db67432c0"
    sha256 cellar: :any,                 monterey:       "9c64fe9a05a00af2ba891e35dcb2bb0afcb4584a1312431015486bbf77f990d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30655a9d970ee905e12ba22f874947ca8d6847c8641e8ba00750f542dbe3ae91"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "pandoc" => :build
  depends_on "boost"
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
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
