class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.3.tar.gz"
  sha256 "ea58d3b2dd0164cf85dfa66044ce1ea2af3080bee2c16ad6f115aa84aa23ba0f"
  revision 3
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "fdc8fa6cfcb71b5a538b99e74cdbbe988babad21029ff02e7b501128f533829c" => :high_sierra
    sha256 "99dd07f133d628ce05a01001349e185c3d42cfc4bd742efb3d677c05da1c0d74" => :sierra
    sha256 "6f410e138e35656a78d610af2cffb243eaa64332684570bc7785e80a2f830019" => :el_capitan
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
