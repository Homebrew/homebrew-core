class Dronedb < Formula
  desc "Free and open source software for aerial data storage"
  homepage "https://github.com/DroneDB/DroneDB"
  url "https://github.com/DroneDB/DroneDB.git",
       tag:      "v1.0.12",
       revision: "849e92fa94dc7cf65eb756ecf3824f0fe9dbb797"
  license "MPL-2.0"
  revision 3
  head "https://github.com/DroneDB/DroneDB.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ce012a0167fc75235c5b6dd7cb05583aa09d4a2197a256e481ce6dbfc9747ace"
    sha256 cellar: :any,                 arm64_monterey: "94d030ef2eed9ab543f7bc26353b3f7e7117c4584108535d94cdf3a479d261ea"
    sha256 cellar: :any,                 arm64_big_sur:  "f6d8ec78823ecaded42a1c6bae5f8ab97998f8b912b3bc9ef8e995b9ab32bd0d"
    sha256 cellar: :any,                 ventura:        "2c723d399fd1fc8e351cc3ee778de1351bc4c5c88067fbde5253101ae2fec8b9"
    sha256 cellar: :any,                 monterey:       "cfe2757a4dc6517bc496997d3dd87e9b5e2ffbb518379e5b2b1cfae27d0126ff"
    sha256 cellar: :any,                 big_sur:        "b8a37bf3e80a30fc719c537b878881d5eaf924827f40a22378445b8edbb1129b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba8637b8a05edfc6d9cabe5c974b97ca9496c52644d5ecb9a560288d7a36de2b"
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "libspatialite"
  depends_on "libzip"
  depends_on "pdal"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/ddb", "--version"
    system "#{bin}/ddb", "info", "."
    system "#{bin}/ddb", "init"
    assert_predicate testpath/".ddb/dbase.sqlite", :exist?
  end
end
