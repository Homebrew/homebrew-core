class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.6.0.tar.gz"
  sha256 "0ec8b58ab972ac8356185af4161270c1b625a77299f09e5fb7f45e616ef1a9a5"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "169e441d33dbf009dc98a4f1e686fa23c478e4230e1ae783421736e6117a448f"
    sha256 arm64_big_sur:  "595a24acc82847328ef30a048defbce2ff4b4001e9863d02eaab72056363262e"
    sha256 monterey:       "86d091787c7b65844959bcea56f0caa07f93c4f7871c22b4b1f7a49a21047e7f"
    sha256 big_sur:        "c4236501945c064b5803b5de46d4a616c21424f356c4b848326de394dd3f296d"
    sha256 catalina:       "bc5fe48c57c4baa6ea8ad6ef65337341a31a8169bbd84cd83c8ed9813a8f2fce"
    sha256 x86_64_linux:   "d25fae955aa9b3785e1f35cc4b95cecfa04b41c889aef8d7aad005c110cb621a"
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
