class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"

  bottle do
    cellar :any
    sha256 "6aff5db2a68b128e8fba0dc703ca307c97710b3c9738ea9976851dd0df1b68a5" => :el_capitan
    sha256 "c2b5e8d04aec3a9f174c43e23eac017342768614b903538be5f0da23206ad18c" => :yosemite
    sha256 "e4bb77cf46bf8209813afec8e40d1c377c3d3c7e7117cd481cd0198c6df7b379" => :mavericks
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
