class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  license "BSD-4-Clause"
  revision 10

  bottle do
    cellar :any
    sha256 "28e47b4fd671bd71072983e55340abe1a6552f5de9de40365656073428378e8d" => :big_sur
    sha256 "29ad8732fb7848d6252f94ba0f1ef5500d93afc762bf7dbe83bd6ae7bcbf631d" => :catalina
    sha256 "f17d1ab719822ecf2db6ff06930891fe0dc2fabbeb9c7c18f7d65b0ae76dfc34" => :mojave
    sha256 "bfc619bd4f796b07e2fc20092bd76701414dcf634311c9d121d54a72907f566f" => :high_sierra
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
