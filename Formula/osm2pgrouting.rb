class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.5.tar.gz"
  sha256 "1d26a92d771d83f044f481989c8c422a0e1579d53d08387c367c9efd1ae605f7"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cd220066b7f205b7b56627315bdfef56e67aaffc4f58ddf827882d99c2b21a8f" => :high_sierra
    sha256 "62423bb28c431eac8f92406adaf71558eb80e7c52d1adf4511ff8b26c4472548" => :sierra
    sha256 "05681f94a2e98ff7d3d06d6795cc708bf59eb33f7ca73bda186118754bfbccc0" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"
  depends_on "postgresql"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end
