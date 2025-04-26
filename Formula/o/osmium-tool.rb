class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "5438f57043c9df05137ca4bd1b1e4a5fb1c9c8c49cb4bec43a5f1ef30ed68fb5"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0cab1102b6f99a0d5556f3f928b3ce66c47168a3af0a2c9f68515688b66cb725"
    sha256 cellar: :any,                 arm64_sonoma:  "40315fb6f5f58d47790c6157cf87b558f77cb69c2b58b26bf1d614b059304a68"
    sha256 cellar: :any,                 arm64_ventura: "0a22fe26b6c72c6e121016d76297cf9d27554bca154d89615bb7b6c810c4b396"
    sha256 cellar: :any,                 sonoma:        "367ed9eedac294312bfd850de02a3b473756c5087a29bc9aa419cd866aad6667"
    sha256 cellar: :any,                 ventura:       "34d3160c4d7488c5a7bde951b81de589cd93477d7d75ba69ba6209424fa7e2a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68645a5288ae2d775939bdd3d860712854ad59d7595ce3bfd167a093f6f2e9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4b896b74aeb6e8c6104bfec7cf7c29f6e0b79d97830c518e8a8331800695edf"
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
