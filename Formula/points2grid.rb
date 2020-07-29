class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  license "BSD-4-Clause"
  revision 8

  bottle do
    cellar :any
    sha256 "caeb87d3165908356f7af813676c9e9caeaa010031ef555efc7ab7e35840e166" => :catalina
    sha256 "daa8956573bbf24c90a630b3af8c732dbae56488d991c7fde2262dd69f79375a" => :mojave
    sha256 "d761f8f93883f4d2517c21f7e328a4daed07bc4ed09fdc684068ebffdadb1b4e" => :high_sierra
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
