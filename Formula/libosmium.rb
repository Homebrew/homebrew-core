class Libosmium < Formula
  desc "Fast and flexible C++ library for working with OpenStreetMap data"
  homepage "https://osmcode.org/libosmium/"
  url "https://github.com/osmcode/libosmium/archive/v2.14.0.tar.gz"
  sha256 "ac385c13b1989cf60f9f2e0395a9d8f73ea557fbe8a35cabb0e5f0b74cf43b49"

  bottle do
    cellar :any_skip_relocation
    sha256 "287a3d67e4f9785b5898e010da7e2a21f546691baa0cdfb4cd0cae71b4a3da07" => :high_sierra
    sha256 "287a3d67e4f9785b5898e010da7e2a21f546691baa0cdfb4cd0cae71b4a3da07" => :sierra
    sha256 "287a3d67e4f9785b5898e010da7e2a21f546691baa0cdfb4cd0cae71b4a3da07" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "google-sparsehash" => :optional
  depends_on "expat" => :optional
  depends_on "gdal" => :optional
  depends_on "proj" => :optional
  depends_on "doxygen" => :optional

  resource "protozero" do
    url "https://github.com/mapbox/protozero/archive/v1.6.2.tar.gz"
    sha256 "1196441f98932c219e5684248249c5fd404023843b0a862034d5daf24eb74433"
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

    system ENV.cxx, "-std=c++11", "-stdlib=libc++", "-lexpat", "-o", "libosmium_read", "test.cpp"
    system "./libosmium_read", "test.osm"
  end
end
