class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  license "BSD-4-Clause"
  revision 12

  bottle do
    sha256 cellar: :any, monterey: "512f823167dbbf5181f29ed8114407b0412d5e078f0f936177fd740e976c0a09"
    sha256 cellar: :any, big_sur:  "2f165bbc5c54e67fbe9c0d52875898ef82689a3a5a1e145a4567b60dd440cb19"
    sha256 cellar: :any, catalina: "1e3ec7e78cd4652a7f43fca2d9917bd61d7dbd66461f3ac428e9d3f62d8bac97"
    sha256 cellar: :any, mojave:   "d3e4412d6830dc9a2c8bcfc9494497eaeb4d9f606ee0211a74ce10f60382aff8"
  end

  deprecate! date: "2021-05-06", because: :repo_archived

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
