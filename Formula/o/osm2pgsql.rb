class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/refs/tags/1.11.0.tar.gz"
  sha256 "6b46313813b816f15ce906c04cd4108bbb05362740e0a1a8889055f4e25977d2"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "78040c337e6e5ba42a3bcd749b24cf0ad280bbd2e3e03c1c6ffc21b10a229957"
    sha256 arm64_ventura:  "eb27ee12e96c35e5eb96f4451913177f69440aad1704494f8d4ebb12b2dcbb0b"
    sha256 arm64_monterey: "91a405d0c803d5841c73b5ced38d95c54311672da1f640954aeab18053f7748b"
    sha256 sonoma:         "c54a0a74bb32c32d4f03fb39e279c2c1b99a40f9c6b52ec94e56c320edf77770"
    sha256 ventura:        "698af979a0d900e1ba2c8fae8f56cb43265471988cb6f0efd5a3471eb89f64d7"
    sha256 monterey:       "9cb60ea66b5901c22396e9e7ff83e6561118159fed7669db46000f1759cf1170"
    sha256 x86_64_linux:   "47140bee36286c930689053f37ae39a76db22c5249ab9ddc97b919e0a97feacf"
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
    output = shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
    assert_match "ERROR: Connecting to database failed", output

    assert_match version.to_s, shell_output("#{bin}/osm2pgsql --version 2>&1")
  end
end
