class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 5
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "50a6b839a749405b1a8ed973112ec404588f9689cb6f9d1838fc93e069113aaa"
    sha256 cellar: :any,                 arm64_big_sur:  "f014ee852c616ed7e4bc83c06137c57a9005a21a6cc3a3d94867c368fcd3d4de"
    sha256 cellar: :any,                 monterey:       "98c0e8d3b2fa3eceda49deaf76a4577bfe2101b298f579a725fa9c06cc426e06"
    sha256 cellar: :any,                 big_sur:        "e8c9c756dedb666562e01bb2a617b11f81d176d1ce4c3caebf6390cd0e510790"
    sha256 cellar: :any,                 catalina:       "3e7d0bcb78fd7b62ebee99080133aae026a77a4b2b8d6f58e84f67b98d777039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "092b3158861c3d646c8fb955c41fa8f4a3999cc6040cc08111c9d7278ce3a52d"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

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
