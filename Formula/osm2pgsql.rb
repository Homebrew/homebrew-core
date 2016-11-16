class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  head "https://github.com/openstreetmap/osm2pgsql.git"
  revision 2

  stable do
    url "https://github.com/openstreetmap/osm2pgsql/archive/0.90.1.tar.gz"
    sha256 "f9ba09714603db251e4a357c1968640c350b0ca5c99712008dadc71c0c3e898b"

    # Remove for >0.90.1; adds the option to build without lua (-DWITH_LUA=OFF)
    patch do
      url "https://github.com/openstreetmap/osm2pgsql/commit/dbbca884.patch"
      sha256 "1efce5c8feeb3646450bee567582252b15634c7e139d4aa73058efbd8236fb60"
    end
  end

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
