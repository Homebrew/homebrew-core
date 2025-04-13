class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/refs/tags/2.1.0.tar.gz"
  sha256 "a02ad5c57a9db5376e2c797560dc6d35be37109283d7be7b124528cb5de00331"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "2f5b80ba7fc61bfae452ba82a5e17f394d795a0ba338be4a9f7d16e62bd4dd4d"
    sha256 arm64_sonoma:  "b3c7ef0872891e1d99d92d6a097e625b522f57bc811e33ad2889477a5c15837c"
    sha256 arm64_ventura: "cc629118eaa6c3cc93f80ccbea14ee722daeba75a49721f6b295c63a2dbca092"
    sha256 sonoma:        "dae5a808a6c14f711088d87643a026eca78920052d8ac294b78cdc50a9dc9cf1"
    sha256 ventura:       "d7998913601502b997308ac58437d428a819236d6b695de2e04b3ff73df17950"
    sha256 arm64_linux:   "f422cf9836c735380b10c849fdc52abfe2ab29fcae99fee74ff2e7e4070f59c4"
    sha256 x86_64_linux:  "678a4c0d5de7d72f626c01563c5d480fdc0656b678ff1893dbeb7b94def4162d"
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
