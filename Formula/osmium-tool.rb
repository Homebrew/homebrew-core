class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.14.0.tar.gz"
  sha256 "67765fe6b612e791aab276af601dd12410b70486946e983753f6b0442f915233"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "366d2a275801b465effedcd9b3c58c4d5032ffc675e65ba9a58feb47b0365195"
    sha256 cellar: :any,                 arm64_big_sur:  "28f759e51d219ce55915e85f62dc929b08ff5a0001440dd0512558c29b308177"
    sha256 cellar: :any,                 monterey:       "276f2228730ebcc5cfe975fcd7163998e7e557c6a1165804b10a5c17f4146b66"
    sha256 cellar: :any,                 big_sur:        "cd50810cc1ce63183d87fc764350b3d45b18891ce220dc12ed4af5965e7d83bd"
    sha256 cellar: :any,                 catalina:       "709ccb8d194a5403e783e45706d59fe341567f191d5220e2231bb80b2e8749fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "244fe31de46dd27780e63eb4cf7ba810e8a56e8f25c1f6d4ad5e9a79a117a546"
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
