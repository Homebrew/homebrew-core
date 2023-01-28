class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.8.0.tar.gz"
  sha256 "b266b50f46fe4d1caddab61d26b39f10ea33b896ec23b8b3e294be4666e7b927"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "0a48e71a3e0a79c4c8c032309fa40bcdd3bb65f6904147045b7ec00f9dbe3524"
    sha256 arm64_monterey: "85d329f3a86a7dd3bad4676dfc827ebbda16d9a56ad5d3062e611544b69ac5e2"
    sha256 arm64_big_sur:  "144c623f4c17b3e228da70e7ea6a0b2f0c449fa288c6e2de55ed6109fa412b08"
    sha256 ventura:        "351fd34612a1d55e7f799a6288e265486ac9e80f8933a81e8b565b1d810f3ca3"
    sha256 monterey:       "51a4ee7f1a07b5b3d7eba482cf390b31226904d09bcbfdbe82d5ea65364fe664"
    sha256 big_sur:        "85f49712c57f9b087dd3f02ee788e7ba823abee1ead3cf722bea293c02d8f215"
    sha256 x86_64_linux:   "b624004e0b3ff4310b8a2c48c2733442869f7217737cb2a1561a4d07609f3688"
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
