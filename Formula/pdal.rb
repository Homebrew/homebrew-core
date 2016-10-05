class Pdal < Formula
  desc "Point data abstraction library"
  homepage "http://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.3.0.tar.gz"
  sha256 "48d48b1fc2a2ce2cf6fba5b28f2455b94a1ccc33148ee0a3c79a4dc041641557"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "5f3124558a1e2ed3d8cbd8125ca2ac338ea622a566a03eb030c088b9f7f14ba1" => :sierra
    sha256 "4a63751d73e54b40f6ce16028f9ca136292720ae2f0873a346abcddad055416a" => :el_capitan
    sha256 "f1f7829dc4cb65be993aed5255f1ed69d53d1928c7cc3b9e396d83fdd8404557" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "laszip" => :optional

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    args = std_cmake_args
    if build.with? "laszip"
      args << "-DWITH_LASZIP=TRUE"
    else
      args << "-DWITH_LASZIP=FALSE"
    end

    system "cmake", ".", *args
    system "make", "install"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
  end
end
