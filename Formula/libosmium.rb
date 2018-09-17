class Libosmium < Formula
  desc "Fast and flexible C++ library for working with OpenStreetMap data"
  homepage "https://osmcode.org/libosmium/"
  url "https://github.com/osmcode/libosmium/archive/v2.14.2.tar.gz"
  sha256 "24b1a73c43e7b8e412ffcd4fb40f1b152edb316ff2799a60e0f31f1eb1212b35"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c233e8c3fe26e8c220fc442f52096d514c6c9896375a0347b0dc8bf69db0464" => :mojave
    sha256 "859c27ebb1cf975cd895b27a628f86a64043ac06763ea1ea634b5479f4135515" => :high_sierra
    sha256 "859c27ebb1cf975cd895b27a628f86a64043ac06763ea1ea634b5479f4135515" => :sierra
    sha256 "859c27ebb1cf975cd895b27a628f86a64043ac06763ea1ea634b5479f4135515" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :optional
  depends_on "expat" => :optional
  depends_on "gdal" => :optional
  depends_on "google-sparsehash" => :optional
  depends_on "proj" => :optional

  resource "protozero" do
    url "https://github.com/mapbox/protozero/archive/v1.6.3.tar.gz"
    sha256 "c5d3c71f5fb56d867ff0536e55cd7a3f2eb0d09f6ebbf636b0fde4f0e12552f5"
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
