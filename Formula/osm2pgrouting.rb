class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.2.0.tar.gz"
  sha256 "bdd3095123cf21ee2f56e5cf04b2ea7b781dea629bff909fa45ebc5dbe50f8a6"
  revision 2
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "5a05bebaabb117bfc0d0e493bb7aeacdc78bcb8bfb4b4427cc4b3ae56d7cc1a2" => :sierra
    sha256 "a46e7b8fecc6a0eaa9f9e3a76b46ce341994eaaacb25e90780cde128c6678043" => :el_capitan
    sha256 "e7bfdbb223bec3cb1744dae76e1f5654ab5a4f07cdf6f99bce83c3ea76b7b189" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
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
