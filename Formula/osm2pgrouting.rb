class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9bcbb99b700443c680e3d1bf0c150228022afbb390f85a0a8374362ff43ebdd5"
    sha256 cellar: :any, big_sur:       "4fb6be202dee51822d2d746023eb329c5ad4b4a5cd5e02e34dc1b81b3ffe30c0"
    sha256 cellar: :any, catalina:      "0aa041c6cbeb8568c6e40e8d3d54724498ef75f5a6db75e3ede0c3d7b24177fc"
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
