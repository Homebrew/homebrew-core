class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.2.tar.gz"
  sha256 "2abb865ebcd2827ffc92f5ea2a82d6ea3d02e654ab97671766da5ab4a7f67418"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "38ae5d80b0714cfa8b523071dc40cd4d3ea181055e54991b5d4d6c28365d39f3" => :high_sierra
    sha256 "a777649d3ef6f0f4b6821bab352602bdd502bc74647685d1b1f5da7c9ad848df" => :sierra
    sha256 "4e5c51fbf20aa8936e55dff4450cb02dc3edcc9b87d7f986bc73a4dc8bef74c7" => :el_capitan
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
