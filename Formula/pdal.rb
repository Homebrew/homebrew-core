class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.4.0.tar.gz"
  sha256 "199b34f77d48e468ff2dd2077766b63893d6be99a1db28cadfaee4f92978aed1"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "89df91c08ea3b515215e02c93b1c50b3bf4226e474335d7d6c178b2b0030e184" => :sierra
    sha256 "20e86c46e3812254079760b335b97e64276b984fb1679355553d502db1710057" => :el_capitan
    sha256 "2a308cd0dc12301dc0cbb44d29f726e0c93dfbd6902fbd2f6cdf06b9be2a5f61" => :yosemite
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
      # CMake Error LASZIP_LIBRARY set to NOTFOUND
      # Reported 16 Dec 2016 https://github.com/PDAL/PDAL/issues/1446
      inreplace "CMakeLists.txt", "        ${LASZIP_LIBRARY}\n", ""

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
