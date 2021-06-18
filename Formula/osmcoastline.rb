class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.3.0.tar.gz"
  sha256 "b08ddcc8cb494a19cbf4d9f1501c47443fe374a4fe171e6f55c730ca1e710689"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0306a9c8556638a4d128bc15d9adc68736a3022333a55beeb227af97eb30a9aa"
    sha256 cellar: :any, big_sur:       "50cfe5960393f3787b938697d26f620ed4218e9a65a16d24e9b4b9ac82bfafa5"
    sha256 cellar: :any, catalina:      "cf181ab2a5da968d965d6712e5756de4d30b950bbfe8eef8f54907be8aeffef6"
    sha256 cellar: :any, mojave:        "b5329fbfabf3ed6f2754c4fafb24ef9f35680e9391c911887c4c0037c33fa430"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

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
