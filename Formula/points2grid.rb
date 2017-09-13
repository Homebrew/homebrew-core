class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  revision 2

  bottle do
    cellar :any
    sha256 "e26dd69fd1d5eab83fcc55ecd0ff5d2a12f32fcf95d31c018339089c92028008" => :sierra
    sha256 "e24498aa357986661c7bc650852876d0d7be0e3767a698d3d45e40b6693893ea" => :el_capitan
    sha256 "f68bd09644b1d6a19dc35b7ae681f80c23dc6d4a8d63936ad9e0530f203c2eaf" => :yosemite
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
