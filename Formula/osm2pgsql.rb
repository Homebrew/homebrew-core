class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.94.0.tar.gz"
  sha256 "9e67e400deca48185313921431884171fb087dfe9e0d21e31857b8b06f20d317"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "be8d98363ad3340824d9660d1ab97e06b2bd1b9e844495a9aefba8532288e5f4" => :high_sierra
    sha256 "812c998ea1e0b1789d697958ce834d0a1edee7bd89e967f13929e31bb8b6a802" => :sierra
    sha256 "943dfa35761a71bf9c71bcc7c92b88d12bdad2a315d4d12113ca4124f94bf68f" => :el_capitan
    sha256 "1fcca8245fbd59e682633759f20724d394af154b45ccbb1a8a6d28176851178d" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :postgresql
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
