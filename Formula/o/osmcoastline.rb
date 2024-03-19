class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "2c1a28313ed19d6e2fb1cb01cde8f4f44ece378393993b0059f447c5fce11f50"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7129acb1c9d8790b0fd50e7a6fca0cb9933d03f6ea56ca9ea455bf68a4d7959a"
    sha256 cellar: :any,                 arm64_ventura:  "df0e075804bac1c78e799080ad8297668f51945b06f3e666b4b9a8527e3d71c5"
    sha256 cellar: :any,                 arm64_monterey: "1ef19b07f64cbc970de11d1475cf98e9e62ac3cf2d1e43a272fa03a5ce07e556"
    sha256 cellar: :any,                 sonoma:         "a3bb3d86820ad33dd7feb7312c55e74e9ad43a49f829d5df92f9687abbc79c2a"
    sha256 cellar: :any,                 ventura:        "5050f910e2da648d6e5e1fac204aa740b3d4338fdd61ddab3fce04fe189febd3"
    sha256 cellar: :any,                 monterey:       "21741707558fb05c03ec05d2000260792c0b904a927b5b973071346e7074dd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1317604f274c36e016b48c980fc26c21475f6aefd358ef69766cfea7b5a56333"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  # To fix gdal-3.7.0
  patch do
    url "https://github.com/osmcode/osmcoastline/commit/67cc33161069f65e315acae952492ab5ee07af15.patch?full_index=1"
    sha256 "31b89e33b22ccdfe289a5da67480f9791bdd4f410c6a7831f0c1e007c4258e68"
  end

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"input.opl").write <<~EOS
      n100 v1 x1.01 y1.01
      n101 v1 x1.04 y1.01
      n102 v1 x1.04 y1.04
      n103 v1 x1.01 y1.04
      w200 v1 Tnatural=coastline Nn100,n101,n102,n103,n100
    EOS
    system "#{bin}/osmcoastline", "-v", "-o", "output.db", "input.opl"
  end
end
