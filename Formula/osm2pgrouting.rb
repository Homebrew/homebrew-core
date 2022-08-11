class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "235fcf5acf4a0b5e63d55505b12fac3fa4eef7a379568da78f854b8816738fcf"
    sha256 cellar: :any,                 arm64_big_sur:  "e33e1d08bb7b945b8b82f2f18aa59cac766442af2ce71110782dfac031146fac"
    sha256 cellar: :any,                 monterey:       "c098f59fda09a8e865d694130889d912e79d2399f3f67c9b52bc388863cce0c4"
    sha256 cellar: :any,                 big_sur:        "a8821651a9d8fe0d3d60226ba1fd41fa51157ddd9ffa402b09cc4e670f1b82e2"
    sha256 cellar: :any,                 catalina:       "8fec29b2e6de42c4d46f1328d3214733b2636fa55a10eab4d9f0c373bf9ad9c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a84374245284b0691602ca06d078c4d229513a54c2662f94d400cd4f8782654"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
