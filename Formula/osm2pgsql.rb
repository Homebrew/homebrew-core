class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.8.1.tar.gz"
  sha256 "9e3cd9e13893fd7a153c7b42089bd23338867190c91b157cbdb4ff7176ecba62"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "f68c6b4751669d9846144161f39b25a7d491a51bf8383ea86f35d232175ef10c"
    sha256 arm64_monterey: "85ff17b822b7fc7ee1c1f943287322df3c4daef6b86a0806635db5eabcc5a74d"
    sha256 arm64_big_sur:  "7de9a23f5693e7ececcf11d725c3a9f94ea23926f86b59c44ed79fdca4d9694c"
    sha256 ventura:        "2e4ba2b036c21b703e3fe7f5970f57817b6e322aef30808d297ec6ec989285c0"
    sha256 monterey:       "657279c73f39a324befeb90730a3be06d22de05e32703bc9c978d4a598231661"
    sha256 big_sur:        "6a142a7afde2a59117a337f64df02a18fc9fb8a63e564611ede61460b48703c9"
    sha256 x86_64_linux:   "f395ab892fe7b6ab665fc6b09235a2665323761aee9aab8d9a626a70df5186f8"
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
