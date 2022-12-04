class Dronedb < Formula
  desc "Free and open source software for aerial data storage"
  homepage "https://github.com/DroneDB/DroneDB"
  url "https://github.com/DroneDB/DroneDB.git",
       tag:      "v1.0.12",
       revision: "849e92fa94dc7cf65eb756ecf3824f0fe9dbb797"
  license "MPL-2.0"
  revision 1
  head "https://github.com/DroneDB/DroneDB.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a820025e9f40542eaec536092cc8f0de46fa457c260567fdc1b9b6d26befba09"
    sha256 cellar: :any,                 arm64_monterey: "760d56a3d3f4c9807ae2fdc9ba5b0d4d40c0bc02421f1c7a1d99409ccae7b77f"
    sha256 cellar: :any,                 arm64_big_sur:  "82908a8e9e61cf8d0c2f658cc1c08cc9fa5141e06ff3f9c7e0d2a9c28f50cb1e"
    sha256 cellar: :any,                 ventura:        "985363214d295e5c8466d7e75ffe800d55bdbc595fbce2710a818e4e0110d882"
    sha256 cellar: :any,                 monterey:       "b847f76834c723bdbcd8289cb3e1c080a4ce26e1bae979d75e40f6c4b4dd60ad"
    sha256 cellar: :any,                 big_sur:        "6877d306762e8a4bf46876b20f8f1d6a5a9295d82767e081c94a85cca3736900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b488c0135024f9df197556ab01de530371a52ee0ad08d407756ab7c03f7e1ace"
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
