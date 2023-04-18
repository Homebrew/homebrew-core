class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.15.0.tar.gz"
  sha256 "0b3be2f07d60dfb93f65d6a9f1af1fc9cf6ef68e5a460997d841c93079c3377b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f06d9f6ae6a228b1fca37fad1bab9721760632c5f3f287d8b4c192beccbce372"
    sha256 cellar: :any,                 arm64_monterey: "0cecfdad7eb06bdf718e7472ab6e40ad691a2733d79379b8b3114203b269a6d4"
    sha256 cellar: :any,                 arm64_big_sur:  "a776cc479cb4a220b7179814464714f69e0dc7f60c96b21eb7807fb2906a6ae2"
    sha256 cellar: :any,                 ventura:        "22a8add357c9ca575aed1d729942f7aee33d664029a19869edffe71c45006c51"
    sha256 cellar: :any,                 monterey:       "c9a15aed4b8af602c9fa1131f63f1dbfd1bd056bac9e0d8d5b7261eb04771220"
    sha256 cellar: :any,                 big_sur:        "fd6e881f2ff097715732c8e1904dc799da8ab7e78dae7bc67a9b9247ac7a6de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c82ba0a54458beefdff33686c3248ebeec6117f91f852520ecc2e51a47fd221"
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
