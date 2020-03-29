class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  revision 6

  bottle do
    cellar :any
    sha256 "560b0951c7eb7c0d29e69d3a0a1696d6b313b1745bb9621b61b1a2e88539fee5" => :catalina
    sha256 "21bc3459f17617d1202823614575bc75c45f9c9ae38d47054e11bb2d2a66f533" => :mojave
    sha256 "7f573051fa8f7e74d92583359e852c68659ff01f0de9718028f306d979a581f4" => :high_sierra
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
