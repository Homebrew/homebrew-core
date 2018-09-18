class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  revision 3

  bottle do
    cellar :any
    sha256 "03d183ed5be6f1ecffdd3439b0ef4287ed2bcdda29bfcd3d6305f2f2e93eb244" => :high_sierra
    sha256 "cb58d67da29769bf2481f60eb4668697699babb90ed18340a6fac217c6d3bd75" => :sierra
    sha256 "498339350edde2ace1538bf8f361ae8a81afb5e7563859687f6309326525db1b" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gdal"
  depends_on :macos => :mavericks

  def install
    args = std_cmake_args + ["-DWITH_GDAL=ON"]
    libexec.install "test/data/example.las"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"points2grid",
           "-i", libexec/"example.las",
           "-o", "example",
           "--max", "--output_format", "grid"
    assert_equal 13, File.read("example.max.grid").scan("423.820000").size
  end
end
