class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.92.1.tar.gz"
  sha256 "0912a344aaa38ed4b78f6dcab1a873975adb434dcc31cdd6fec3ec6a30025390"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "711e41e1c947ada70e3cd0ef9d21093cf8c23f91f9b44e66b52a54492e7d086d" => :sierra
    sha256 "231e87a48d4763fa53d49852ee04a7023673506d7021abe1aebfa51c413369a9" => :el_capitan
    sha256 "d0ade47e074fa81be405c6efcf8911b7160979a101d0a0bc0c428ee4ad82264e" => :yosemite
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
