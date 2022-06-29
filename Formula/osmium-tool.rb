class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.14.0.tar.gz"
  sha256 "67765fe6b612e791aab276af601dd12410b70486946e983753f6b0442f915233"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "68153b1dd4a7345c12b31f2eef46611692cdd266faf7d42ac62dce363b4c8c76"
    sha256 cellar: :any,                 arm64_big_sur:  "146d6921247de6acae063e1ee645d72b81db7df97aa3b1c5d17547801c48ccb7"
    sha256 cellar: :any,                 monterey:       "62a658f397e5a4fad798b16eef26b9986c2ad400ea6ed24849d3f531df674aac"
    sha256 cellar: :any,                 big_sur:        "84f2f2a1108eac56c6a4229ebf589ce73365f31612e89b4648e19f565ee76706"
    sha256 cellar: :any,                 catalina:       "c9443d5de34ada93c0d59a14a719b5702d412230a0bf20b8e008f55d907760bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae2f553c8c29a9f3e4eb152afdc70d7ffed454652d7ee4c2d55d225f3082c04a"
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
