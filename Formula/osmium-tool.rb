class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.15.0.tar.gz"
  sha256 "0b3be2f07d60dfb93f65d6a9f1af1fc9cf6ef68e5a460997d841c93079c3377b"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f782b2826a0f45e4e5ec8f1caadde19de246c7ac93c0bed055f501461d7f07e9"
    sha256 cellar: :any,                 arm64_monterey: "932f82cfc739211c09b1fbfdbbf33bb3f4af7ee353dc25912fb9c495da3651f8"
    sha256 cellar: :any,                 arm64_big_sur:  "9f30edea5da6046ed3e55f87b2bf83ab9e7590a88d0d77768b643b639611327d"
    sha256 cellar: :any,                 ventura:        "8dfb0c03cf98a7d641dad804457c6592cd2bd604062c24d0e5f659672232bcb2"
    sha256 cellar: :any,                 monterey:       "39cad6166336a30d45105a7082495861df9239db625f2ecafa7b1c8ca1c4ef34"
    sha256 cellar: :any,                 big_sur:        "88947b3e84566348f662dc3676a624e0e4a8153e3157d9b3990960e3f23d6d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd9d7ee47c1fc8f70bf6e611d83ff3e3db6762e18abdc92c1dcde5cad6d26884"
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
