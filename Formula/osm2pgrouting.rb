class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.2.tar.gz"
  sha256 "2abb865ebcd2827ffc92f5ea2a82d6ea3d02e654ab97671766da5ab4a7f67418"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "f316088743cfe002a0c1756a4c5b39737aaa61a5a0b0cbf793e2ad01c8786ba1" => :high_sierra
    sha256 "0e9f437b2974d14f5d0873ce2d23fd19bafc6c2951e2230ed6fc54e58b0adb5f" => :sierra
    sha256 "c932ca2df7b3973d00bb0ca1b2c6e91da93908d212407ae40c61103219c7cfb0" => :el_capitan
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
