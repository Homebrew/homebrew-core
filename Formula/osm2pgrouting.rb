class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.4.tar.gz"
  sha256 "32aba345013e137e39cc7bf74466cc6c97b93e256f2754e617a00f61f57eb8c2"
  revision 1
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "5769b38d9088a52f6ee9f52cad4f8bb7519743c78e79972c33570e525f6a0a7d" => :sierra_or_later
    sha256 "b5d772a54d0f247d357442b244fd9bf581f98c1b2c7b4b2aa760eb8a3f5fe6c1" => :el_capitan
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
