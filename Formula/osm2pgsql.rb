class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.94.0.tar.gz"
  sha256 "9e67e400deca48185313921431884171fb087dfe9e0d21e31857b8b06f20d317"
  revision 2
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "a1298aff6b0c3f9ebbf5a608443ab47b6281d019fef9bf3239b5541da1cb9825" => :high_sierra
    sha256 "bd76ecc1cab3c799ae8302571c10ece0d61260c021f1b445fa39713e0ed1111d" => :sierra
    sha256 "51e48dcedbb306acb8b8d662883b19d77a688a3f44d07f2167018f8daf384de4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "postgresql"
  depends_on "boost"
  depends_on "geos"
  depends_on "proj"
  depends_on "lua" => :recommended

  def install
    args = std_cmake_args

    if build.with? "lua"
      # This is essentially a CMake disrespects superenv problem
      # rather than an upstream issue to handle.
      lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
      inreplace "cmake/FindLua.cmake", "LUA_VERSIONS5 5.3 5.2 5.1 5.0",
                                       "LUA_VERSIONS5 #{lua_version}"
    else
      args << "-DWITH_LUA=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osm2pgsql -h 2>&1")
  end
end
