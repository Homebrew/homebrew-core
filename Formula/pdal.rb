class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.6.tar.gz"
  sha256 "66baf8510225b34ee24021731758251cd70657dd578c210ae86c78d158f283eb"
  revision 3
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "f40210764a91dea38d8383abe8858975bc97fc407e0be936f9947a5090ee1391" => :high_sierra
    sha256 "7a801114b043934f4b1aaa4c8242e13858a7cf4bbff6e9ce010cb24c7f4547e5" => :sierra
    sha256 "49ada132c5b3918bec11e713329fe82cb4e4cecf35218e385d6d7e46858081bc" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "pcl"
  depends_on "postgresql"

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DWITH_LASZIP=TRUE",
                         "-DBUILD_PLUGIN_GREYHOUND=ON",
                         "-DBUILD_PLUGIN_ICEBRIDGE=ON",
                         "-DBUILD_PLUGIN_PCL=ON",
                         "-DBUILD_PLUGIN_PGPOINTCLOUD=ON",
                         "-DBUILD_PLUGIN_PYTHON=ON",
                         "-DBUILD_PLUGIN_SQLITE=ON"

    system "make", "install"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
  end
end
