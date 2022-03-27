class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.6.0.tar.gz"
  sha256 "0ec8b58ab972ac8356185af4161270c1b625a77299f09e5fb7f45e616ef1a9a5"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "aa3e782aca8953d6ef78b2397fef8da5fcca0b191ea6dd3da4d81e4a54e2118a"
    sha256 arm64_big_sur:  "e7bf361f2d2ffcd646e84dfbed4e775fc0a2880524ecee3d3d446c63524cbd80"
    sha256 monterey:       "4e3e12fcbf10774a8526bdb1387111034fcc34f87b15cbc0eb582f811d5f0166"
    sha256 big_sur:        "39cba6f1ce9a9039e99c32f130d5ef88932c098355673aaa898e7ca0215a37b8"
    sha256 catalina:       "01af4be809ca6182195e1a65c8722db7b1044c6aa5e765a29ceb66d31aee1e9b"
    sha256 x86_64_linux:   "7b87389923ce699c38bd8b3f7ede176114b43290549a344ff0d5ef8ec984fd98"
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
