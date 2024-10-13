class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/refs/tags/2.0.0.tar.gz"
  sha256 "05c2355b4a59d03a0f9855b4234a3bdc717b078faee625e73357947d1a82fe89"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "44e982673a866dec6f55a0ed34981dabce3fd941abd1dd4afea370edb518d41e"
    sha256 arm64_sonoma:  "a2fdfb145a93bf00cc5dd31fda4978c1cc920bc36a0d2eca6baac03d7f60c91d"
    sha256 arm64_ventura: "e95d13d81e46720bf56cb72972c0faab3f27ed8a89911cf35eabba5c7699e19b"
    sha256 sonoma:        "34a75d5b8fb063e4edc427c780197c2d89089f92d11f2bd1c62f00533420f0fa"
    sha256 ventura:       "b750fbd5a9b0ca469b4c19f3360c004fc8a1127aacce15a73f79d66b086984c9"
    sha256 x86_64_linux:  "a4a8f8ba54aa13e536e0a994b66bdd4b4d3ba0a780846236432a613118926f24"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "nlohmann-json" => :build

  depends_on "boost"
  depends_on "geos"
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

    args = %w[
      -DWITH_LUAJIT=ON
      -DUSE_PROJ_LIB=6
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
