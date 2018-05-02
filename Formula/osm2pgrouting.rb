class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.4.tar.gz"
  sha256 "32aba345013e137e39cc7bf74466cc6c97b93e256f2754e617a00f61f57eb8c2"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "470c02534c55675c79c76e1b9e7434c751c02458847c7a37c124d7ff5640ef5c" => :high_sierra
    sha256 "1d9816373d3be292775229ede1d9413d36bb71de11334a2473e8e5356a97f27a" => :sierra
    sha256 "88ce1c875c760dbe9ee5cff7c435c4253c2e366403862ab0d053679fe115d7d6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"
  depends_on "postgresql"

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
