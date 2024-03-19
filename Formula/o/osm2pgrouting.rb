class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 11
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "efd4dbbcf0ae64df2d5a22811b54414c4a8bff53764f39afec9000ec9bd914ba"
    sha256 cellar: :any,                 arm64_ventura:  "7332c848e651a87d46157f97f1eb0135b240deb63fa122ec7ebb52edd47d94cd"
    sha256 cellar: :any,                 arm64_monterey: "21082cb107d90ece3ad09e0564c796134968a4281aba314cd2589e2768a3fc22"
    sha256 cellar: :any,                 sonoma:         "be310691c6c44b00dbefb4f252115e081e0309734eac7739d6d26e17aad5d650"
    sha256 cellar: :any,                 ventura:        "41616beb97fcfc68130c401c8b4a935adac4008129d7ae0040d7be3e0d6b8492"
    sha256 cellar: :any,                 monterey:       "9ca2005237332b32e8fabe032146dac6deb037b72d6c2ba46fe35697196581b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13aaac0ea03bb2c05bfa276d7e9b446577810e1b6c2054a84fe987200dcee057"
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
