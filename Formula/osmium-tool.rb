class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.14.0.tar.gz"
  sha256 "67765fe6b612e791aab276af601dd12410b70486946e983753f6b0442f915233"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ef6fb69e1cb749d35ffab87e2f842efa0f16c57047e96ab895bf5f063e487cc6"
    sha256 cellar: :any,                 arm64_monterey: "6d2223c0fa9866d66db794f80ee1d2771327156aa77fb5fa7fa62ca31e11b4a5"
    sha256 cellar: :any,                 arm64_big_sur:  "cddf3e857d857be6ce79fe4e6f5e055e26b6a6f2ebbbd34000c9df936273eb7d"
    sha256 cellar: :any,                 ventura:        "f733109b5eaab596ecdbe2fa07dd02a630f189c274e8b32eaa3193b0d7058f10"
    sha256 cellar: :any,                 monterey:       "1c2c65baf505cd961b7d2a21fdd35aa90ffad5408c049f9d5245249c66eaf804"
    sha256 cellar: :any,                 big_sur:        "bef07c4ffd4e49b17ac0cbe31f2b03ebe5e8af0179ab2da595cdf574325848ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d0abf08b249ebb86ce347e7983847966b888cd5437e9e7eb05ab2f0f94b0695"
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
