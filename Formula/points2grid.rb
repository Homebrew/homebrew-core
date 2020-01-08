class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  revision 4

  bottle do
    cellar :any
    sha256 "55fc987d27a9dd759111258641196dc1d48856c5f4a828fdffedb6ca49b8e63d" => :catalina
    sha256 "2353397675ec9f8fe4f8cf701645e4dceedf01030ee54ff61720521ba6afa046" => :mojave
    sha256 "4d2c91405313abf7fedda20628ce2b11b5bc3f76a42862a40e90d5252ad34e7c" => :high_sierra
    sha256 "58d99c2471ebd555d76e36c1108d352bb4e9b7594459ea3381c5f4a6232bfca3" => :sierra
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
