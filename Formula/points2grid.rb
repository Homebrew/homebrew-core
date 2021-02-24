class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  license "BSD-4-Clause"
  revision 11

  bottle do
    sha256 cellar: :any, big_sur:  "20a3a688d66d5bdad77ee08abaced2afa047e147b5096d6b24530faa21936a1e"
    sha256 cellar: :any, catalina: "48645a46886d20460d53df48c0ea777ce788e600cd4cab0a5994b89fe253e43c"
    sha256 cellar: :any, mojave:   "6f7cf1d33b5c66044ecdb7afddf198b96959eb0b7ab6281b9fbcd9dad7f995aa"
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
