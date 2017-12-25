class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.3.tar.gz"
  sha256 "ea58d3b2dd0164cf85dfa66044ce1ea2af3080bee2c16ad6f115aa84aa23ba0f"
  revision 1
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "e7f4b47ac2a06065a09a45ed1e279f8ea3fedb309eb2b712df1195dc643a5334" => :high_sierra
    sha256 "b6ac0fe8660b60e731f689532a1428622ce0948344f13e08b98ccda6f2301178" => :sierra
    sha256 "65d574dfc31b39cecf2c18561420d21779d976760acb2e501e1c74c3f0438eb2" => :el_capitan
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
