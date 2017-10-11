class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.0.tar.gz"
  sha256 "8a9b8aa58240bd3e8e74ea64598ea1df0ff0b84a1250e23649a2f55adbef1898"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "b9ef8eb8c8f1fd12ea923f899fe165872cd48e8f13520520279f75b785640669" => :high_sierra
    sha256 "baa296928d1bbdf59fb46922774bbe30735f6988894967329fa05f606791dd6a" => :sierra
    sha256 "22a7391bc2e14a8eb3c81d55978b19109cd33a7459c36ebbb5ec293a941c2742" => :el_capitan
    sha256 "216b3c435f16d61407888c0f64d1a57ff3579b3ef199617d5d922668704414f6" => :yosemite
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
