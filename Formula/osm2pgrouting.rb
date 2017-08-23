class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.2.0.tar.gz"
  sha256 "bdd3095123cf21ee2f56e5cf04b2ea7b781dea629bff909fa45ebc5dbe50f8a6"
  revision 3
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "c5453b05142ad650cf90c97cd2e84314dfd7b7c0431afe0f2974d366163f2b88" => :sierra
    sha256 "a0c7c19f8016721dc805638a9d7db6cfa8f17855fc40903cfcb8334b5d80f9a5" => :el_capitan
    sha256 "60060d8f8b52e535f39962a1fccefafdc180324f90e27707432ab37942b4a576" => :yosemite
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
