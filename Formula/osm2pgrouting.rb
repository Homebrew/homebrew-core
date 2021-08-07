class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "aee032629018b2a5b6ff95094e549727a5e288d44723515b87fe8995f5dcbdc0"
    sha256 cellar: :any, big_sur:       "e52d508d8bb1fd160e5d940fdb27ef7989f001ed5fe1e98be654aa693264ce5f"
    sha256 cellar: :any, catalina:      "3152527b2ea1cbac663a018e5b3b70a1c466234aa94a74ec6c9f58e783891c2f"
    sha256 cellar: :any, mojave:        "a5a34b5dc9ea3e2661903bb43dc76ece8196fe0bb4b34fc70a4979ec8027e981"
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
