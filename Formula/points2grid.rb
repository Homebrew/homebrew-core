class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  revision 8

  bottle do
    cellar :any
    sha256 "c1bfc65265ba2e73bd824c1e8bb91c575f47263cabb057a090fd131c97ceeb1d" => :catalina
    sha256 "cdf22957709e730862dd8e819ada452fcd59b6ded53b346c28070671bd0bb86c" => :mojave
    sha256 "c6bf998f59605f4f6b3687a0dff33ae3dfe467c587be3a401337e1c36c02f439" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gdal"

  def install
    ENV.cxx11
    libexec.install "test/data/example.las"
    system "cmake", ".", *std_cmake_args, "-DWITH_GDAL=ON"
    system "make", "install"
  end

  test do
    system bin/"points2grid", "-i", libexec/"example.las",
                              "-o", "example",
                              "--max", "--output_format", "grid"
    assert_equal 13, File.read("example.max.grid").scan("423.820000").size
  end
end
