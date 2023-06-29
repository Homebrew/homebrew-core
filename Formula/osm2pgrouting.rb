class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 7
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b2390aa42b599c46d79054f81be44370dbe59508e42dad51a7b9c16bab2aa66"
    sha256 cellar: :any,                 arm64_monterey: "c0a1872b86b8db313da01ffb9cd6ff7862b5f10a80c45b24ffa72c377057f057"
    sha256 cellar: :any,                 arm64_big_sur:  "221c938da938bb62b8b870db2830eda71cc6bbb308e50c4953886cb14fe2516a"
    sha256 cellar: :any,                 ventura:        "78b5ccbb08115b0e71f9f15a64219e719281ed0b923c12093157feab452a5a53"
    sha256 cellar: :any,                 monterey:       "fbd65fbd6e34e9b2cbb535778c52f2615420c6c39bbecec535593ed51c18d25e"
    sha256 cellar: :any,                 big_sur:        "77873a7aebce26036994789d4972ad0fae78e898148f88354e9f07d414a69ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ece428d8d0985ef01e08d931a446546c135ca9d4d9ac76f5d34fefd074a641c"
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
