class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.92.0.tar.gz"
  sha256 "b741cfdf6489fd5def721f75a9558b8cda53165dda7ca9548fcc5b43e163ee77"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "b0488ed843c82f461a63317318a061feb3dced47d5893160663e226b0facf93f" => :sierra
    sha256 "df494859c12bfb2a7626451c557c5d449c65144b5584cf0ff222d4fef53e9320" => :el_capitan
    sha256 "7281553a580928e89f05ad8a705383a902ee274dbe1ad63a3a00c4d164539d2f" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :postgresql
  depends_on "boost"
  depends_on "geos"
  depends_on "proj"
  depends_on "lua" => :recommended

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
