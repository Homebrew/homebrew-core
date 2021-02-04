class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.4.1.tar.gz"
  sha256 "33c4817dceed99764b089ead0e8e2f67c4c6675e761772339b635800970e66e2"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 big_sur:  "49332a29a27bbc5489c71544a839cfe634f4773288a62977ec12e5981da91c34"
    sha256 catalina: "0f7ee597c6ada7d36cb043c0338f2d4e4a04a5e5260c0219083795c58939247e"
    sha256 mojave:   "4334f733878244f353934604d533e985d15853bd76c760ed84844453af9c9a6b"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "luajit-openresty"
  depends_on "postgresql"
  depends_on "proj"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", /set\(LUA_VERSIONS5( \d\.\d)+\)/,
                                     "set(LUA_VERSIONS5 #{lua_version})"

    # Use Proj 6.0.0 compatibility headers
    # https://github.com/openstreetmap/osm2pgsql/issues/922
    # and https://github.com/osmcode/libosmium/issues/277
    ENV.append_to_cflags "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"

    mkdir "build" do
      system "cmake", "-DWITH_LUAJIT=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Connecting to database failed: could not connect to server",
                 shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
  end
end
