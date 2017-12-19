class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.3.tar.gz"
  sha256 "ea58d3b2dd0164cf85dfa66044ce1ea2af3080bee2c16ad6f115aa84aa23ba0f"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "a36761125b93c168b28f7760b0d94fd2b04f0ee7e710836e52821997db87f9fb" => :high_sierra
    sha256 "1681df19e5f5b68f7fd49ebc2681d80bfdfc4d7e622176132d22afe872e836a9" => :sierra
    sha256 "07b02a0ee0a62a561abd6df1fa142491a283b90dfe5eb5f7bac43990aabb2af3" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"
  depends_on :postgresql

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
