class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/osm2pgsql-dev/osm2pgsql/archive/refs/tags/2.2.0.tar.gz"
  sha256 "567dad078f8a66d6d706ac1876b5251b688109d16974909d89ce2056d6e9f258"
  license "GPL-2.0-only"
  head "https://github.com/osm2pgsql-dev/osm2pgsql.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a5f9ab6a4a201781ae815d913f773583684dca4538e0aff2d992ca8e9b5a177a"
    sha256 arm64_sequoia: "c22d991054d0f3ca640e949d2be019afc6d5e7bd8825f359eab3e8b7604acda8"
    sha256 arm64_sonoma:  "14964a21c76e55705881b99d27a459ed1a098126fe6d3632368df967129ea9dc"
    sha256 sonoma:        "77ff1260704e17ec3aa45de6bcc3947b3dddf0c31693b266305201ca7f148545"
    sha256 arm64_linux:   "c554b99264e3a52791e14c304dae74e0c37f9d87082752e79169b00b6c1ef231"
    sha256 x86_64_linux:  "719e9ab7dbc8d76cc317006f9492c619bcd79a40b24b76056e04a9d6f9264b11"
  end

  depends_on "boost" => :build
  depends_on "cli11" => :build
  depends_on "cmake" => :build
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
    rm_r(Dir["contrib/*"] - ["contrib/fmt"])

    # TODO: Switch to external fmt when v12+ is supported
    args = %w[
      -DEXTERNAL_CLI11=ON
      -DEXTERNAL_FMT=OFF
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
