class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.6.0.tar.gz"
  sha256 "0ec8b58ab972ac8356185af4161270c1b625a77299f09e5fb7f45e616ef1a9a5"
  license "GPL-2.0-only"
  revision 4
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "2b1c23342805ddc22b8c69c2f91a24d33703fab6fcbb381870c2f60179058f70"
    sha256 arm64_big_sur:  "77e304190222d4da2d28b9db1c468a1b172cbf29d90598bcd683c7418840d0f8"
    sha256 monterey:       "278ba1a3e688722170d489a157fdf8ea6011483133bad8dbaefccc05dc07c8d1"
    sha256 big_sur:        "0751305ff2a2d2cf937234c7741e6919a26978e8fa992444287c1904fa34713f"
    sha256 catalina:       "49ac82bbb990d26771605e6dd82dce3594cccb5d8717ced6632b807d16f88395"
    sha256 x86_64_linux:   "b81aa6a292f1edcee0fc87f495925e09081d4c821b64371535251e759b9154e4"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "libpq"
  depends_on "luajit"
  depends_on "proj"

  uses_from_macos "expat"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", /set\(LUA_VERSIONS5( \d\.\d)+\)/,
                                     "set(LUA_VERSIONS5 #{lua_version})"

    mkdir "build" do
      system "cmake", "-DWITH_LUAJIT=ON", "-DUSE_PROJ_LIB=6", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Connecting to database failed: connection to server",
                 shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
  end
end
