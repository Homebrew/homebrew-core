class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.6.0.tar.gz"
  sha256 "0ec8b58ab972ac8356185af4161270c1b625a77299f09e5fb7f45e616ef1a9a5"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "b657c6e2d1a9b8c1174c6d9ec2fdfc55ab1f98b0c9884b0b3db5ee79460749a3"
    sha256 arm64_big_sur:  "6d362127dc5476f3e69da88987b8940adbca5990935eef487f07f18af9f395a1"
    sha256 monterey:       "81fc3542ae3cb36ff075b259c140ff6622da49402e22e207f7a637ad4aaf5e69"
    sha256 big_sur:        "459c759c2c6293b9d8a0f4606925586dfa27a343e6da31300bcab307e2c45ba1"
    sha256 catalina:       "53ba2486b1f36e3e254b695f1403d054f8c40cc4d1145ca447671f5f84994efa"
    sha256 x86_64_linux:   "7030049e1144f3a1c561f0e8e10ff6b96c0215129aca20e2898485f4d8da4cb8"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "luajit-openresty"
  depends_on "postgresql"
  depends_on "proj@7"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", /set\(LUA_VERSIONS5( \d\.\d)+\)/,
                                     "set(LUA_VERSIONS5 #{lua_version})"

    # Use Proj 6.0.0 compatibility headers
    # https://github.com/openstreetmap/osm2pgsql/issues/922
    # and https://github.com/osmcode/libosmium/issues/277
    ENV.append_to_cflags "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"

    mkdir "build" do
      system "cmake", "-DWITH_LUAJIT=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Connecting to database failed: connection to server",
                 shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
  end
end
