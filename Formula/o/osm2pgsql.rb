class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/refs/tags/1.11.0.tar.gz"
  sha256 "6b46313813b816f15ce906c04cd4108bbb05362740e0a1a8889055f4e25977d2"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "a4e3b44ee3c1717a0eff88f03678d3fb88b2e7bbc1c0c1c0ac05ab8a1d605556"
    sha256 arm64_ventura:  "999c603e48cd96f0c33b1db28ef55eef999b7c24484a09dcd5d198189eca72bd"
    sha256 arm64_monterey: "42d4c065c00f567cc477c4b831cf5071c407297aa52076d7c0fc3b7ae32b1040"
    sha256 sonoma:         "11e38c0e29beb114c08466e4dce0a52ab2fbcd364c7dcd175cb99d43009de7fc"
    sha256 ventura:        "65ecc28dc6aa3d9592917be707643bdc96be5b58b877dcce2310ff828848c19e"
    sha256 monterey:       "a8a9a207d9922f6dff4d4a422fdaca49292ae5cb5b4f8080d998cdfa9591effb"
    sha256 x86_64_linux:   "984e9ebf513a1d2e5ce54d65ff6cbcd54902e60d897daffd07c8cdeaeef9c0aa"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "nlohmann-json" => :build

  depends_on "boost"
  depends_on "geos"
  depends_on "libpq"
  depends_on "luajit"
  depends_on "proj"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

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
    output = shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
    assert_match "ERROR: Connecting to database failed", output

    assert_match version.to_s, shell_output("#{bin}/osm2pgsql --version 2>&1")
  end
end
