class Libosmium < Formula
  desc "Fast and flexible C++ library for working with OpenStreetMap data"
  homepage "https://osmcode.org/libosmium/"
  url "https://github.com/osmcode/libosmium/archive/v2.17.0.tar.gz"
  sha256 "4a7672d7caf4da3bc68619912b298462370c423c697871a0be6273c6686e10d6"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a670f374f814891e2db3d00de8a156d2d177cbce453435388fa180de343d1f27"
    sha256 cellar: :any_skip_relocation, big_sur:       "71432c9f74dfe76886bbe1e89d128bf5fa80e2e1ef9d3ea15a18fc9d7a739f34"
    sha256 cellar: :any_skip_relocation, catalina:      "71432c9f74dfe76886bbe1e89d128bf5fa80e2e1ef9d3ea15a18fc9d7a739f34"
    sha256 cellar: :any_skip_relocation, mojave:        "3e4d4f6cc29087f12b21f8354c44b0088d7dea65064b9d705d95217ddc9ab248"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build

  uses_from_macos "expat"

  resource "protozero" do
    url "https://github.com/mapbox/protozero/archive/v1.7.0.tar.gz"
    sha256 "beffbdfab060854fd770178a8db9c028b5b6ee4a059a2fed82c46390a85f3f31"
  end

  def install
    resource("protozero").stage { libexec.install "include" }
    system "cmake", ".", "-DINSTALL_GDALCPP=ON",
                         "-DINSTALL_UTFCPP=ON",
                         "-DPROTOZERO_INCLUDE_DIR=#{libexec}/include",
                         *std_cmake_args
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

    (testpath/"test.cpp").write <<~EOS
      #include <cstdlib>
      #include <iostream>
      #include <osmium/io/xml_input.hpp>

      int main(int argc, char* argv[]) {
        osmium::io::File input_file{argv[1]};
        osmium::io::Reader reader{input_file};
        while (osmium::memory::Buffer buffer = reader.read()) {}
        reader.close();
      }
    EOS

    system ENV.cxx, "-std=c++11", "-lexpat", "-o", "libosmium_read", "-pthread", "test.cpp"
    system "./libosmium_read", "test.osm"
  end
end
