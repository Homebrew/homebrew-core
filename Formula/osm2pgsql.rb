class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.5.2.tar.gz"
  sha256 "4af0b925180ead2710eb68af28f70c91a81fb21dde5f80659d78e9fd14cf52cc"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "a837f3ab487af02f2ae13344bd91a41644094f612fc238180da4ef60167541aa"
    sha256 arm64_big_sur:  "0eab054adc8db93d4a4a763a1ae60f54c46c1b8baeb3468214530c7655ebeb0d"
    sha256 monterey:       "b90452686d04d2a3a8ba17a49ac303620e0bc85d7538f1d79d290029d82062d0"
    sha256 big_sur:        "950c282a2156674cdca3fb9dec75b1a1d2cf77b8dbc12691a514c522e33db8f5"
    sha256 catalina:       "f3b60b0fb98b49abe321ae232eca6dbbf47427606e66d81cdab45de3896d3dbf"
    sha256 x86_64_linux:   "88603f93c3dbe35342622ec9f3076c3b69a08723e65f69111b82395bb3433a5b"
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
