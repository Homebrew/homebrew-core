class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.4.tar.gz"
  sha256 "32aba345013e137e39cc7bf74466cc6c97b93e256f2754e617a00f61f57eb8c2"
  revision 1
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cd220066b7f205b7b56627315bdfef56e67aaffc4f58ddf827882d99c2b21a8f" => :high_sierra
    sha256 "62423bb28c431eac8f92406adaf71558eb80e7c52d1adf4511ff8b26c4472548" => :sierra
    sha256 "05681f94a2e98ff7d3d06d6795cc708bf59eb33f7ca73bda186118754bfbccc0" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"
  depends_on "postgresql"

  # Fixes the build on Xcode 9.3
  # https://github.com/pgRouting/osm2pgrouting/pull/230
  patch do
    url "https://github.com/pgRouting/osm2pgrouting/pull/230.patch?full_index=1"
    sha256 "485ce2d0086041e439c028911abf9f60cb55d8eeb66d5d6fd3ab39eff466fb8e"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end
