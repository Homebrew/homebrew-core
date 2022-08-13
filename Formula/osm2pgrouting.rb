class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "655fce8ebc42541f74c19891cb7f95cb3ea349a5a9f56a55eaf9d48b86142f81"
    sha256 cellar: :any,                 arm64_big_sur:  "5221c89b5f7ad69f683919032ed1f08c69a2854d249ec3cbd1ea32ed4a2a5c78"
    sha256 cellar: :any,                 monterey:       "1b2baeec219eb69778e7e393ec47705bb3971d716c360d3ad96a8edba35c21e2"
    sha256 cellar: :any,                 big_sur:        "82155e14a81382a35fc23b64169b76fc934e4fd0121c30f21733adc49a05c5c5"
    sha256 cellar: :any,                 catalina:       "c1623261ff58d3e98dd528da974fc6828c7d39915551004f0b20c17042efe856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "702b3512f5944637b24477d057329a7c379202a479eff7fd25f7029b1285e434"
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
