class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.4.1.tar.gz"
  sha256 "33c4817dceed99764b089ead0e8e2f67c4c6675e761772339b635800970e66e2"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 big_sur:  "639cf61fb8a546f66ca7edc840156f1eb7c5544244e984ab9482b7ab20d0a8f9"
    sha256 catalina: "558cf99448c7c80aec0356cfd0addbf5c6eeb5457c5c10a09eef9ee8ea3cdff2"
    sha256 mojave:   "b7b04dcd4f31b4b1a4765752f2cc484b64d6e4b6bd10b66d8d47734ad44a3f68"
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
