class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  head "https://github.com/openstreetmap/osm2pgsql.git"

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
    sha256 "7f388ee56a6bf0d685434823d238ebbd8ca01e74320c862892e61e21b24b9a08" => :el_capitan
    sha256 "17c80db14f36b5831b03a4026d3d970ae29c782344c11c5fbec9cf19716a3e6d" => :yosemite
    sha256 "ef2655f802ca66c3cb137d80be9fcbe9fae64743c0f67c0b0e3944faddbc8913" => :mavericks
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
