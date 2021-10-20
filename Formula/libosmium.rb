class Libosmium < Formula
  desc "Fast and flexible C++ library for working with OpenStreetMap data"
  homepage "https://osmcode.org/libosmium/"
  url "https://github.com/osmcode/libosmium/archive/v2.17.1.tar.gz"
  sha256 "6faa7952aa1210dcd9ae4ef83e7653a4f8eb880e6a4e5b37f87a5d4835f6327b"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a8a971c899fefb81bb0a4bf4e6a047c6477b31a96bdef065670223e2ff1b976"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build

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
