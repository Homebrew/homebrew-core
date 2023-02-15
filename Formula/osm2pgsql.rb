class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.8.1.tar.gz"
  sha256 "9e3cd9e13893fd7a153c7b42089bd23338867190c91b157cbdb4ff7176ecba62"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "5b96cf1df818a0ae5f10a2cbfd59508f9790ce05a434a30ef144b47a2a2f79da"
    sha256 arm64_monterey: "aee3815145e3e507c66e07f0e47e7ceff1b6adcff48574aeb569a332058e95d4"
    sha256 arm64_big_sur:  "8543d1b9680dfd92804c3d5aa102fbb96b54c22345e6c7dca2a36090bd638ad9"
    sha256 ventura:        "bbbf1abc9997892f428dccb2375a55ebeab520dc1f67a97ca02406af9969c235"
    sha256 monterey:       "e1d1a7e6f7a1851daeb5f6c95602e6feaf5213cd7d3a9ef5769e6c3fedc413a3"
    sha256 big_sur:        "4368fa3d82ae292c11bc5a981e2b4b2d1ab41528e738cfe1d671f7319880bb7c"
    sha256 x86_64_linux:   "cc3a246d2f3dd747911f1acd00ed3e4690ad7b4a9dbfcd5477461d40694c8185"
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
