class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  license "BSD-4-Clause"
  revision 10

  bottle do
    cellar :any
    sha256 "02e7629e9842b057273e411b4b391befb3292ac1d5ade3265583abbe1e5cca63" => :big_sur
    sha256 "258e0d77ef6437bc8e2a06a1ccd53aa8c1cf7dc8b3b6406b2eb06bc4d72679ac" => :catalina
    sha256 "60bb2e63790d16f5b060f0ce6982f306d202c1b206e2220581c6b9cba53cce94" => :mojave
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
