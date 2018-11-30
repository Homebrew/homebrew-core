class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.6.tar.gz"
  sha256 "c4b1f45ff7a9a184956182e40016fdd9455718821adb25822e2ef8182d2712a6"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "6a054598f01996ff1dad2b7efd50a3d3fecfe1bd1f4d4b5788fc4cc06e125429" => :mojave
    sha256 "570f091f6fa641eaef5a1339d935c94e04aae1715e740ba29556f648b97dfba1" => :high_sierra
    sha256 "5c9da0dbfe4592eee781221042abe4809b684fe06835732dd30c5e6b021cefa6" => :sierra
    sha256 "f6d7fd453858b29b4299dc8860c68978210c8504a8108b9d3e5ad3e3bd9ea5cb" => :el_capitan
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
