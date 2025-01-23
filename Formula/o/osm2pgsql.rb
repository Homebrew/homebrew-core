class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/refs/tags/2.0.1.tar.gz"
  sha256 "b9d5c95ccc928aafc3c6caccb8b5bc19c4d48a5d1640cada07388d0dbf171ecc"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "c2b85172a4fb8af79b730e55c416f45408d87b404282ec28ebab8b7ac7963a96"
    sha256 arm64_sonoma:  "5144613e747f884357aafc9f5e62fb8120ed1e6e4957a967f07162277625a08b"
    sha256 arm64_ventura: "2e9370cbdcbf28dbb5162c0ac75b36882f6ea1a50bfcda0268a7611b0791f1f8"
    sha256 sonoma:        "5513cac57505618afd7c960e6d72e0e69744f5ec34cb89ab4ed414d9ebe9dea4"
    sha256 ventura:       "66a8bbd44ddead269184f0423265ed5cc1b79815f52ab7663352a484fc12d959"
    sha256 x86_64_linux:  "e59d9c880f39a84f9d5c0804204a6b9efcd85598c1316d1c59dffee324773ef2"
  end

  depends_on "boost" => :build
  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "libosmium" => :build
  depends_on "lua" => :build
  depends_on "nlohmann-json" => :build

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

    # Remove bundled libraries
    rm_r("contrib")

    args = %W[
      -DEXTERNAL_CLI11=ON
      -DEXTERNAL_FMT=ON
      -DEXTERNAL_LIBOSMIUM=ON
      -DEXTERNAL_PROTOZERO=ON
      -DPROTOZERO_INCLUDE_DIR=#{Formula["libosmium"].opt_libexec}/include
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
