class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.6.tar.gz"
  sha256 "c4b1f45ff7a9a184956182e40016fdd9455718821adb25822e2ef8182d2712a6"
  license "GPL-2.0"
  revision 2
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "5e935d46ae6532b2cd75b73ebaf13bcbf25472e29e0281236fdd002c3317f3bd" => :big_sur
    sha256 "99b349358db3adfb8a52dfcd2cfde049cecd5cea0b46cc6fa2a4fb6e2e9b4523" => :catalina
    sha256 "c99a46012e8a582678e3b28e73f8c570606477d2b76d125dee5070fde5516b5c" => :mojave
    sha256 "1ec262b471c1dd25b7609b5c36b53798375fb5d1015eb0d968a8023a698ed113" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpqxx@6"
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
