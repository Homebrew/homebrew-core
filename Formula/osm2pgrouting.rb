class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.3.tar.gz"
  sha256 "ea58d3b2dd0164cf85dfa66044ce1ea2af3080bee2c16ad6f115aa84aa23ba0f"
  revision 2
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "5657ea795498a53e039d631ad8b265d7439a59faa19f65f66fa88a70ce020920" => :high_sierra
    sha256 "2e009f15f2047927f7f813a1fa3b80c1c6bf5ffee065f88764d1062d3c75e4d6" => :sierra
    sha256 "35433c7da78aabf4595625730176565ef3ba218819e2b7d2a68c2d1a344cf1df" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"
  depends_on "postgresql"

  def install
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "RUNTIME DESTINATION \"/usr/bin\"",
              "RUNTIME DESTINATION \"#{bin}\""
      s.gsub! "SET(SHARE_DIR \"/usr/share/osm2pgrouting\")",
              "SET(SHARE_DIR \"#{pkgshare}\")"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end
