class Libosmium < Formula
  desc "Fast and flexible C++ library for working with OpenStreetMap data"
  homepage "https://osmcode.org/libosmium/"
  url "https://github.com/osmcode/libosmium/archive/v2.17.3.tar.gz"
  sha256 "ff85d55ca83d77fc41f6b7ae77f3d8d4337d299cbb4cc60c00e1f9d90d94e71b"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "013d1b84de5cb7c583bff533abd6a4503c3dc53c52be14925413e23871f041fa"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

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

    system ENV.cxx, "test.cpp", "-std=c++11", "-lexpat", "-o", "libosmium_read", "-pthread"
    system "./libosmium_read", "test.osm"
  end
end
