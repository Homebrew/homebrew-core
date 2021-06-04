class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.7.tar.gz"
  sha256 "afbe3ff74c9b9b7b1350362fc839e1466335d57f84941af19b5a663fd58aba0c"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    sha256 cellar: :any, big_sur:  "b3a5695ec0da3196e6a0db7fff372f4792e9b1afc8b1cd2f7608973deba24916"
    sha256 cellar: :any, catalina: "fc5653e1d1c6f002603fb38aa117260feff5c4784e0c5cb04d9cc0a72f331d0d"
    sha256 cellar: :any, mojave:   "1a09c4bd948c742744f6dc377cbacf03281ae0bd705341b05ada202e540ef43d"
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
