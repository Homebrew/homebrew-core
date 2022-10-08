class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.7.1.tar.gz"
  sha256 "76c303bfb28440eee546d0f7327565a08d6dac20a915f95dbb4bf21f2e691141"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "77819439477d8223a3bb0b1289e45f28d7e5d548dbf4670e3365de6cc3ade306"
    sha256 arm64_big_sur:  "1c8c5486a45a7507c6e20e505d59ed338be32414ae8938ac9bed38606bbab76d"
    sha256 monterey:       "093c11ed82bf2bdc76f66149ef47721687a600ea3330bb4828118c16f8d07d7f"
    sha256 big_sur:        "abfc6b1a9f834feef34bef6dfa3c5332e445be238916992e90adeac3e0e5f28a"
    sha256 catalina:       "563cc7be1efeeba1f8426138c11fa20a3ce1ec381952d4a975181767395d77f6"
    sha256 x86_64_linux:   "5168a536bbd24c235d7e40265119d8ac7c2e2d3b751ccd24fbb13e0657c11c96"
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
