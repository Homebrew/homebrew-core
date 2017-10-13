class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.6.tar.gz"
  sha256 "66baf8510225b34ee24021731758251cd70657dd578c210ae86c78d158f283eb"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "47c6a9f26061c1b03db03c9c4e0e86bac819d021ad14c614e8943140e990ec04" => :high_sierra
    sha256 "fa7b413b522192c334d6d9a8b682f6024793fdb1d63d6e8287d4bd71432f2c49" => :sierra
    sha256 "f36b4f1f4e313fb50a2f502a025d2eac88afde01c63e896d3c60b4a94cb335df" => :el_capitan
    sha256 "7af040afe945077595f4160d6ef220e5e36965afeb59d2b066788e701516c99f" => :yosemite
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
      # CMake error "Target 'pdalcpp' INTERFACE_INCLUDE_DIRECTORIES property
      # contains path: ... LASZIP_INCLUDE_DIR-NOTFOUND"
      # Reported 7 Apr 2017 https://github.com/PDAL/PDAL/issues/1558
      inreplace "CMakeLists.txt", /^        \${LASZIP_INCLUDE_DIR}\n/, ""
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
