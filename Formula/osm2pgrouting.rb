class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.2.tar.gz"
  sha256 "2abb865ebcd2827ffc92f5ea2a82d6ea3d02e654ab97671766da5ab4a7f67418"
  revision 1
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
      s.gsub! "set (SHARE_DIR \"/usr/share/osm2pgrouting\")",
              "set (SHARE_DIR \"#{pkgshare}\")"
    end

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end
