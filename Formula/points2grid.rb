class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"

  bottle do
    cellar :any
    sha256 "a40f65b783cf1a86abe7478c905ebb4b378e98a9970fd7abc2534dd8a6d68706" => :sierra
    sha256 "0f30c1a159b2a7efac5caf2c77484832e281b787dd9e034fc130a2ae1743d9f0" => :el_capitan
    sha256 "4c7b0feae78f632c8195d3d8e009178f40b8a2758a509ce139dba6edab52784d" => :yosemite
    sha256 "0e57a93ae8dde68b2e1e9d8d41a4085de4c0dc29a8ba10ceac638f3896f463e9" => :mavericks
  end

  depends_on :macos => :mavericks

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gdal"

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
