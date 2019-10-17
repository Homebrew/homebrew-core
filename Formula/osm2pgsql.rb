class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.96.0.tar.gz"
  sha256 "b6020e77d88772989279a69ae4678e9782989b630613754e483b5192cd39c723"
  revision 1
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "e4f782810a9998759252feab613524c3c6cc2dc614b3511ef15f6f2ed4972f98" => :catalina
    sha256 "0ebba50375c8d63d13db3e8d1dc2b326d5099758f272c6fd5216be6497bba2ae" => :mojave
    sha256 "2ad65d522d094b6b9b742bca379d66f9999658050efbb19f1ad79fafbb1f823d" => :high_sierra
    sha256 "59fa881b0b8e0f1f0c542881814f21896d676bdcf6ab71c823f1676b0432be87" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "lua"
  depends_on "postgresql"
  depends_on "proj"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", "LUA_VERSIONS5 5.3 5.2 5.1 5.0",
                                     "LUA_VERSIONS5 #{lua_version}"

    # Use Proj 6.0.0 compatibility headers
    # https://github.com/openstreetmap/osm2pgsql/issues/922
    # and https://github.com/osmcode/libosmium/issues/277
    ENV.append_to_cflags "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osm2pgsql -h 2>&1")
  end
end
