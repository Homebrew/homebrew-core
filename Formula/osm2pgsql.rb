class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.92.0.tar.gz"
  sha256 "b741cfdf6489fd5def721f75a9558b8cda53165dda7ca9548fcc5b43e163ee77"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "e0faa9d16e381814c88c6640dbc2dde471392e830c14dddd10f1b3a3713584e2" => :sierra
    sha256 "6bca4c3a41ef7c8dec991f9d704f5d4197b4a160526da12318d6a8adf861b5e5" => :el_capitan
    sha256 "9a33fce7b6f63a056c1fdfea9ca60ecc9a0efdab41fe6a1f442a3caf1f669e41" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :postgresql
  depends_on "boost"
  depends_on "geos"
  depends_on "proj"
  depends_on "lua" => :recommended

  def install
    args = std_cmake_args
    args << "-DWITH_LUA=OFF" if build.without? "lua"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osm2pgsql -h 2>&1")
  end
end
