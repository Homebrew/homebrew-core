class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  revision 1

  bottle do
    cellar :any
    sha256 "55975d6c5872fb54dfbdda2871bb12ffd23d4135852fa052250d514d6bd542c5" => :sierra
    sha256 "232680ccc1f7173349daecda3009b50b7cad3ddab0489b0427c968cb553aa2bc" => :el_capitan
    sha256 "39f3d174fd8e893c7ce071872d306659e83725145e5edecf94bd0308fb44c2fe" => :yosemite
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
