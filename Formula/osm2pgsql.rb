class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.92.0.tar.gz"
  sha256 "b741cfdf6489fd5def721f75a9558b8cda53165dda7ca9548fcc5b43e163ee77"
  revision 3
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "3b1468c569e609cf6642366809dc4ad211e6be664e5210437108f7bc2d9bc86f" => :sierra
    sha256 "2882cef756b57d21fb04e2fc83cc6f6a53ad712899fa1c198566ef2f417db9b8" => :el_capitan
    sha256 "dc95004d1e07581f573ace750ec04209746cb1be0bd69916cb01dd6d95bbc4a9" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :postgresql
  depends_on "boost"
  depends_on "geos"
  depends_on "proj"
  depends_on "lua" => :recommended

  # Compatibility with GEOS 3.6.1
  # Upstream PR from 27 Oct 2016 "Geos36"
  patch do
    url "https://github.com/openstreetmap/osm2pgsql/pull/636.patch"
    sha256 "54aa12fe5a3ebbc9ecc02b7e5771939b99f6437f5a55b67d8835df6d8d58619a"
  end

  def install
    args = std_cmake_args
    args << "-DWITH_LUA=OFF" if build.without? "lua"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osm2pgsql -h 2>&1")
  end
end
