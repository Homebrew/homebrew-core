class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "f98454d9f901be42e0b6751aef40106d734887ee35190c224b174c2f27ef1c0f"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd0d21dc080d2b571d2578b44c2afe064dea0098e7e9ad4e3ffbd731099ebcdd"
    sha256 cellar: :any,                 arm64_ventura:  "e8aede9852983954a795ad5feba52e5af7489e3b115edc9cb015f5aeeea14dcc"
    sha256 cellar: :any,                 arm64_monterey: "6cc6becea818334ee87c8fd83b7a64ddb2aad443de982ad0c7c1b5ce147b387d"
    sha256 cellar: :any,                 sonoma:         "574af3654f45beb15f313d3036cf3d43c20b25d75bf767bc8df3314478145aed"
    sha256 cellar: :any,                 ventura:        "be683bcf46e09596a379467e8a04b066e5db61a8cad17f5acfc7fe7e11bf8226"
    sha256 cellar: :any,                 monterey:       "4f8a6d611e53e50e399055f4446189211039961a607ae94c535d055b5a8e051b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca4cbbba7059ea0336d0c94250f2a7e469d9572848539ecdc1e4f0a559c607a3"
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
