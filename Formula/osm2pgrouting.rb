class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.6.tar.gz"
  sha256 "c4b1f45ff7a9a184956182e40016fdd9455718821adb25822e2ef8182d2712a6"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "f940abbd92f04c51959b955799c0f2361b4c2b4cac5fbc95f258d7a791bfa701" => :mojave
    sha256 "4b34f6ab8f079979cec37fe7a70f703103c0a42f9837af4cac546407314b030d" => :high_sierra
    sha256 "e1e4a8753dbf77e93fe0e89c96ead722456f1657cb90fc38c03df27715c31fd7" => :sierra
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
