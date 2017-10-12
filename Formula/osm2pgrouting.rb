class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.0.tar.gz"
  sha256 "8a9b8aa58240bd3e8e74ea64598ea1df0ff0b84a1250e23649a2f55adbef1898"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "a4ef893061d83d9a19f54d024f7e908ea9541d106a25557e61195c38b1bea704" => :high_sierra
    sha256 "7ce918a10a08a8849f7db69370a594bac6f3ce6274c10f6bb4d9539a543dc03d" => :sierra
    sha256 "a9644ae921e22f85751a59fc9f50e71e744d532613048b35cd657812b4adca0f" => :el_capitan
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
