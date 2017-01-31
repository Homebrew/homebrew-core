class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.2.0.tar.gz"
  sha256 "bdd3095123cf21ee2f56e5cf04b2ea7b781dea629bff909fa45ebc5dbe50f8a6"
  revision 1
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "8ea798b06d437c03de3d6650923b1507e66c1f4375871e9a01604e1de5eb1045" => :sierra
    sha256 "51f98a582af555b60abebabaf6aebc8792f571bb686a01c0dd340aef1a8d47b4" => :el_capitan
    sha256 "68a2b95a5acdbd4b25d8933243ebcb0205e2ca42a6996a26be9ded2726477b31" => :yosemite
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
