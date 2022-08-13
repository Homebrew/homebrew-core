class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.6.0.tar.gz"
  sha256 "0ec8b58ab972ac8356185af4161270c1b625a77299f09e5fb7f45e616ef1a9a5"
  license "GPL-2.0-only"
  revision 4
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "e5cfe24753f30f192f3a51dc714250c74dcf41294700495442977f3db18dc091"
    sha256 arm64_big_sur:  "7e4512d8cbf14c168340c5f569c9c4caa8f9666eb5fe4f5324b99cdfb77cbc34"
    sha256 monterey:       "c55c28a4a7d61e2ecc74e439d178c2479ba6bb1f70d5a4c8a419432141d477f8"
    sha256 big_sur:        "461f444d3d7da2f549b445e3d16839ac42105c01aa859b086d6ca7f9f8c141ca"
    sha256 catalina:       "2094de94b79ac68652e5671b360d9fa158146b6c3d0263dee84f5008c7c52d99"
    sha256 x86_64_linux:   "753d07bfe5ff3a913144fb09cd892918f77569e9a5b44977fc37ad7d93c27a97"
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
