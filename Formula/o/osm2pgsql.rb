class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.9.0.tar.gz"
  sha256 "f568618809930d550fc21a1951180b58b72c091235e4b0bc93477e4c27d54e88"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "5b855eb9b537cc57c832f5eac56308b63e1cd0d474616bdf49be140355741074"
    sha256 arm64_monterey: "4acfa4074baf4175ffeec2438208261e8c60a82ad80a8f86ebd2bf6b18f993cb"
    sha256 arm64_big_sur:  "397e72dac95d603ffb164ff5d556f55496c580bc18916576bf694c8efb4fcb03"
    sha256 ventura:        "57f423d54d381d90aa1a9b2cd107e51aa821c8fa6b519c01dfd0b15fa9a5b270"
    sha256 monterey:       "2eab576a4b605c9d8c1dfb78cb449121ef1fa7bb1fe69ba087a5f5c65091977b"
    sha256 big_sur:        "70b1f7a27335d206c367e5d18cd371a1defb0629d5aa51bf8952134138869210"
    sha256 x86_64_linux:   "5fae3f08d98d62d899d7f1cbcdcddb46a323442d940efd3b02df170bfaba862a"
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
