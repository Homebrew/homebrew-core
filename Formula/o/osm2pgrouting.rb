class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 10
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "27696e4d49a2a92ab504b6c5a71cfb23973c60746b365a33c628f6d5defa5757"
    sha256 cellar: :any,                 arm64_ventura:  "cbbde7712058faed30bf9fc5dd3075d993822a27d3e10405d8b61de677722e39"
    sha256 cellar: :any,                 arm64_monterey: "d31b762f57c7a4af4af62219b9baff45d9b85f5aad4056eb20c1f218e90c65ab"
    sha256 cellar: :any,                 sonoma:         "56e85bbdcc8e2bdc5a45223345abc9262c7b037abf14ee499a1f97e9b4fb5937"
    sha256 cellar: :any,                 ventura:        "67877596e13484b268234ea4010ae8864bbd9a54957e0a7fb5b4c2a01c295151"
    sha256 cellar: :any,                 monterey:       "4ec67139eaaa4662fbf22135d6bacc76c2189c820e3d5c80fa02f5f37a0ea6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f10bd66530448a056f5349607e9b299dfb3a4403714f8f791a0ea91d7df7227"
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
