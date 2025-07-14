class Libosmium < Formula
  desc "Fast and flexible C++ library for working with OpenStreetMap data"
  homepage "https://osmcode.org/libosmium/"
  url "https://github.com/osmcode/libosmium/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "8f74e3f6ba295baa7325ae5606e8f74ad9056f1d6ab4555c50bff6aa8246f366"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "02ce13c6248f0566b846579f0325c94f2e2385e9f00c7163b04b27636304ce57"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  resource "protozero" do
    url "https://github.com/mapbox/protozero/archive/refs/tags/v1.8.0.tar.gz"
    sha256 "d95ca543fc42bd22b8c4bce1e6d691ce1711eda4b4910f7863449e6517fade6b"
  end

  def install
    resource("protozero").stage { libexec.install "include" }

    args = %W[
      -DINSTALL_GDALCPP=ON
      -DINSTALL_UTFCPP=ON
      -DPROTOZERO_INCLUDE_DIR=#{libexec}/include
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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

    (testpath/"test.cpp").write <<~CPP
      #include <cstdlib>
      #include <iostream>
      #include <osmium/io/xml_input.hpp>

      int main(int argc, char* argv[]) {
        osmium::io::File input_file{argv[1]};
        osmium::io::Reader reader{input_file};
        while (osmium::memory::Buffer buffer = reader.read()) {}
        reader.close();
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++17", "-lexpat", "-o", "libosmium_read", "-pthread"
    system "./libosmium_read", "test.osm"
  end
end
