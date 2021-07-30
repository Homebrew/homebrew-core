class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.5.1.tar.gz"
  sha256 "4df0d332e5d77a9d363f2f06f199da0ac23a0dc7890b3472ea1b5123ac363f6e"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 arm64_big_sur: "b9ac7032d2720894bcf462d15d743a8f2d6e5827777aaf280afc8038acdbceb8"
    sha256 big_sur:       "7a053ba31f800eb1d49e9ee4de6b54ade35f4f527ece2c1530ce1e79ff2909b9"
    sha256 catalina:      "8480abcc84286248903f547c3a16ea7a81c90f57eee3872bce2c07dc41f1d239"
    sha256 mojave:        "b304583a22752a1d811490c8eb44d9c5f316619d782bc2fd19f29837871b4ecd"
    sha256 x86_64_linux:  "da88eacf8454b778c9ac2bbb6cc40b3344b26070073769e24875be79096f0c35"
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
