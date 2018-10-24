class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.96.0.tar.gz"
  sha256 "b6020e77d88772989279a69ae4678e9782989b630613754e483b5192cd39c723"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "f549068475acd4c81f6a0da191702ea105d9c29f89e1c811cdde6c001909f031" => :mojave
    sha256 "ec4a8aec68bfece0b4b1e5709c74ac5a28cad76d2266da76fca4405c4c6b6d32" => :high_sierra
    sha256 "ff4584cbca8c5ad00a3581b7c86d33fcc47336289c74952d3953200333fbabc1" => :sierra
    sha256 "b3872d5006c687a1be8be67df8912a139865fc99e79b6e74f8bfea947032e953" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "lua"
  depends_on "postgresql"
  depends_on "proj"

  def install
    args = std_cmake_args

    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", "LUA_VERSIONS5 5.3 5.2 5.1 5.0",
                                     "LUA_VERSIONS5 #{lua_version}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osm2pgsql -h 2>&1")
  end
end
