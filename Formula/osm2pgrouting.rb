class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.6.tar.gz"
  sha256 "c4b1f45ff7a9a184956182e40016fdd9455718821adb25822e2ef8182d2712a6"
  revision 1
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "4f0887c9a9b548ecdf8e04f6ecb9038eea4937dfcd9374afcb608917998be9cb" => :catalina
    sha256 "3ed89abec56121bbd4a6be5002c00a3ea5406c085311259aa59005f93108088b" => :mojave
    sha256 "50abb343eee9a3158ac73941990edc6d973f7f7e865af326bae1ee65623fcf3a" => :high_sierra
    sha256 "b576bf2e32adac14ab0be1ffbadfe543c9e9d127308231b3a57a40138807433b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"
  depends_on "postgresql"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end
