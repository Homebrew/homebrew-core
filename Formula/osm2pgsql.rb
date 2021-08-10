class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.5.1.tar.gz"
  sha256 "4df0d332e5d77a9d363f2f06f199da0ac23a0dc7890b3472ea1b5123ac363f6e"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 arm64_big_sur: "ece6fdfa41191aa1f7f5c82b6c197e668e5550cfae6d72271bf0253f3a4d166f"
    sha256 big_sur:       "3b55656f6199e13de0705586978e4fd6bbc24b8a4125d0380f7331ac171f5a2f"
    sha256 catalina:      "f400b7edec6fcd957360a69c43212868a3a7a0dcd3b8c0a96a9cd1d3b725ec90"
    sha256 mojave:        "e9b3b5a2cac886bb1afbfb9586cdda65c01a50248727a04c5e93ca2bd7e686f7"
    sha256 x86_64_linux:  "bb9666b44020e017f3867c7a2d71d739988f0953a12eca0200c65955db994f5c"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "luajit-openresty"
  depends_on "postgresql"
  depends_on "proj@7"

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
