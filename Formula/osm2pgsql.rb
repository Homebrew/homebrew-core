class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.94.0.tar.gz"
  sha256 "9e67e400deca48185313921431884171fb087dfe9e0d21e31857b8b06f20d317"
  revision 2
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "d728f4e5375c17dff50d3a98d40f5d1cd4843bceb27ff57ee3066f3e001e7189" => :high_sierra
    sha256 "8073f2a6e9f17398df2bd54bef75fe191e88e3d5e71696ceac7a8089a17b5599" => :sierra
    sha256 "36dc78a4580eebfcd3593f61bee3fbbf80ec44e444adc7167cd03315aaa06ced" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "postgresql"
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
