class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.92.0.tar.gz"
  sha256 "b741cfdf6489fd5def721f75a9558b8cda53165dda7ca9548fcc5b43e163ee77"
  revision 2
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "59299d681ba858bac58ab5bba717a5baf420601919df01b9181ffdb587c6ad56" => :sierra
    sha256 "b36405e1b6c6a251a2b7903a2b76157ef7d67cea1c4701b214115507b60e31be" => :el_capitan
    sha256 "0a00f8b8f4eb1733919d9fde00817ef17f95dc863b4405052d4f8950136ac1a1" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :postgresql
  depends_on "boost"
  depends_on "geos"
  depends_on "proj"
  depends_on "lua" => :recommended

  # Compatibility with GEOS 3.6.1
  # Upstream PR from 27 Oct 2016 "Geos36"
  patch do
    url "https://github.com/openstreetmap/osm2pgsql/pull/636.patch"
    sha256 "54aa12fe5a3ebbc9ecc02b7e5771939b99f6437f5a55b67d8835df6d8d58619a"
  end

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
