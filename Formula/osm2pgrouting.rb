class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.2.0.tar.gz"
  sha256 "bdd3095123cf21ee2f56e5cf04b2ea7b781dea629bff909fa45ebc5dbe50f8a6"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "cc4bad23a3c966466e516e1c2818145d6702c71f57d957cc17befe7bf2a983b0" => :sierra
    sha256 "e2eeea2392b2febb64ad5beb1e974ba10f9b38012b6d41edb9111b6cc3e19911" => :el_capitan
    sha256 "24a7fbe3a7079145f76b8e9f70c3f1fd02bd82e4324ef782950d3f98678530c8" => :yosemite
    sha256 "6fced08cc54a523a0923a7091b735c45becc63d51ca16775b381fd455150a124" => :mavericks
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
