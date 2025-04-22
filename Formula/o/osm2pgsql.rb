class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/refs/tags/2.1.1.tar.gz"
  sha256 "b084e4a79317043410ff13ece4350a801384bd34e6c2c5959fa1e1424ce195b0"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "ae6732f4577555118510370adccaeefe194a43638f3edf8c6fa7d74883b70daa"
    sha256 arm64_sonoma:  "602428b81887e949678e2f9782e11ab3896374620192652e7ddb6f5454ea5151"
    sha256 arm64_ventura: "fdfaabdf6101e1536d70b8e21b37c5a1cecaf347e191dd957b032a853be0d09e"
    sha256 sonoma:        "16d621193033944ea29ecfb9e66d73ace20b600f6847cf8ebfc1532cdc6e1904"
    sha256 ventura:       "7f08026614bfb7a6322d5b35f8f3f143aec648c28de9fd6856db4c7a493bd030"
    sha256 arm64_linux:   "9733201f7d985df8d12dfb1c16f9b6d36ed9615ac3fa0102ddf9866795514ef7"
    sha256 x86_64_linux:  "a8ca71c29e64154abd15af163974e84eb4b78f603a0efa3a2c492df80af18274"
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
