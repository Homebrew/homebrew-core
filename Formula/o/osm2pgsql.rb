class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.9.2.tar.gz"
  sha256 "dc30a3ad9a27f944e4169be9a8e07ee09711901536ddc8fcf4a292bd3aec51d9"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "e3abb7bc3dabcb12115b63fa0c22ee813ca44f9de209a6b2e2c0a6e5fe2cd5c9"
    sha256 arm64_monterey: "7776ceee6332172c3b37fe41417ddbb09bd61f02a85548f56039387a5c7bace4"
    sha256 arm64_big_sur:  "d95bdd9864736f1d08dbe0aa762117fb15dfd0f06cc32ba91fa3622342474fa0"
    sha256 ventura:        "667fb46bad11718d43d21780a211a5128a20d780003c96b0611609e921678a94"
    sha256 monterey:       "1a6f32dc3c69aec68483d7f391de6cae4e752e78845d328695446fbacad717ff"
    sha256 big_sur:        "633b99819065c8da59a60aeb74829cb0127e1982fac21e986770cf13303cbc89"
    sha256 x86_64_linux:   "578e65d82cb65809d13408ea008c7743ce8abe34d951eff3bfe51d6f93e525bb"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "nlohmann-json" => :build
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

    args = %w[
      -DWITH_LUAJIT=ON
      -DUSE_PROJ_LIB=6
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Connecting to database failed: connection to server",
                 shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
  end
end
