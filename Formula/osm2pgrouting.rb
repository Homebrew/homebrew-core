class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7a16273c49d8a30b48460b6ec896d979d06c06e46bfb38b655633190827779cb"
    sha256 cellar: :any,                 arm64_big_sur:  "eae9b9f7b4fc4229bc85a8e484c3c85b6fdf10bb4eadf334efd3bc9d5a46cde4"
    sha256 cellar: :any,                 monterey:       "8ad1a0713c06714fb3aa63f6ddbf4c73985cd71b74cec74d3b89c2f881c222c4"
    sha256 cellar: :any,                 big_sur:        "e9c0bcc9363b8291d5e3e729b0ac32c14036dfcf7c4eb4920e46b5c8bec924e8"
    sha256 cellar: :any,                 catalina:       "fca50921c8c7058ee70868858e3581cbd90606db8617a057a6af6f9b95393c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "335729da47edd61bd7a81daa473098c0023a7bb3cead156840fec8b9375b344e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"
  depends_on "postgresql"

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
