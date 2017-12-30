class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.3.tar.gz"
  sha256 "ea58d3b2dd0164cf85dfa66044ce1ea2af3080bee2c16ad6f115aa84aa23ba0f"
  revision 2
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "4cd752c1766abbb714226eedb1211df4cdeda318724838fdd4c077d2e351036d" => :high_sierra
    sha256 "23e0e9954f4000e34fd5c48244b7840f5affdee5a497bf76ee2fc839d901de8a" => :sierra
    sha256 "ed756e5080c1275a22b3339c3f582b2d1a1aef5baa6521ce0648cfdf2173ba72" => :el_capitan
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
