class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/osm2pgsql-dev/osm2pgsql/archive/refs/tags/2.3.1.tar.gz"
  sha256 "e90461bd78787fd5cf82f73ac4bc0cfccbc4f498f35dce59eb4d168a380d6ac0"
  license "GPL-2.0-or-later"
  head "https://github.com/osm2pgsql-dev/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "522d9266142eff6e01870ecb9ce4a3ab322d89cdb92b108481b005f7acccad2e"
    sha256 arm64_sequoia: "fdb18378a006c5797178a76a00be72348b2b658612af277fbe847b6973ec2f0e"
    sha256 arm64_sonoma:  "cee292968039e234fb2cb5acce2e7f81c0cfe33420507977dc7ee3a283dc5074"
    sha256 sonoma:        "fb230f552f453fa4ed10a7a0e34e0b04f778e06bff56b76af5d7b5fb047dd4b1"
    sha256 arm64_linux:   "1b3e63b1f6874b8716ce1af840b354ca3de5c67053626fab357b07f1fccaad91"
    sha256 x86_64_linux:  "c333cae12f6d30c322a6239e722de3d55204cb02db905e57013db0647f63bb94"
  end

  depends_on "boost" => :build
  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "libosmium" => :build
  depends_on "lua" => :build
  depends_on "nlohmann-json" => :build
  depends_on "protozero" => :build

  depends_on "libpq"
  depends_on "luajit"
  depends_on "proj"

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", /set\(LUA_VERSIONS5( \d\.\d)+\)/,
                                     "set(LUA_VERSIONS5 #{lua_version})"

    # Remove bundled libraries
    rm_r(Dir["contrib/*"])

    args = %w[
      -DEXTERNAL_CLI11=ON
      -DEXTERNAL_FMT=ON
      -DEXTERNAL_LIBOSMIUM=ON
      -DEXTERNAL_PROTOZERO=ON
      -DWITH_LUAJIT=ON
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
