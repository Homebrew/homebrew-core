class Dronedb < Formula
  desc "Free and open source software for aerial data storage"
  homepage "https://github.com/DroneDB/DroneDB"
  url "https://github.com/DroneDB/DroneDB.git",
       tag:      "v1.0.11",
       revision: "f9f7d50c1f2b49072e4046cb2bd2d9fd67066252"
  license "MPL-2.0"
  head "https://github.com/DroneDB/DroneDB.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1e8b02c5d87c54efc48a250e6206341f19d85c31cc760a0f4b0635bc26785942"
    sha256 cellar: :any,                 arm64_big_sur:  "d1ae7059f738fc74a2ccc6bb33ede385d5a67f538a8c7a992c671b4143087cba"
    sha256 cellar: :any,                 monterey:       "5e895e4d10ce1689ebb5ab6b03176b7cf0e071b2fe69ba40e10517f8a086fab1"
    sha256 cellar: :any,                 big_sur:        "7956e91ce02c028410cdcd6fdcc19641dedb0beb951bccd54c27444fc24f0e7c"
    sha256 cellar: :any,                 catalina:       "4f45c646c818ab8120482929b9a9acebb6701895098b4f5e5fcdf08679ea02ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec3c51925ff58c523efa4dae502c2cf2d14011d0c627c814c73d453ca7c1976"
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
