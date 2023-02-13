class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.8.1.tar.gz"
  sha256 "9e3cd9e13893fd7a153c7b42089bd23338867190c91b157cbdb4ff7176ecba62"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "2c59aa140480693d0803de5fd1289c59f133581c099f07e10420d1e02190f7eb"
    sha256 arm64_monterey: "5d9658b16a3c1625d4982622ef17d12aa85192dbbc4fcbd79bbe77babe993aa6"
    sha256 arm64_big_sur:  "93c931121d11f8db4ab9ad57abc5d04a98b6c0716097a0e1df2fe0e4b4dce1bb"
    sha256 ventura:        "b15158365e7e54240ed9136df6db58da2077986436f54337163a4538ba4c92f4"
    sha256 monterey:       "d0b7bd622135350073619a5589b5ad21b09c008240fda11dd5048479226b0d41"
    sha256 big_sur:        "819259fe065d22f78c458bb9cb5a1a0a067c7d1208aa5c3bf551ecea636f9f5c"
    sha256 x86_64_linux:   "5f5bdee2b687ffbaf1e7fd5556c10af3f1ea9de120e20a9460a49c0e3f22ad3d"
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
