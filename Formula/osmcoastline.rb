class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.4.0.tar.gz"
  sha256 "2c1a28313ed19d6e2fb1cb01cde8f4f44ece378393993b0059f447c5fce11f50"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "326cfe7b3cc49dd9a9f58b6ad49854a13c83e83a26160ba3bff8786ed34794e7"
    sha256 cellar: :any,                 arm64_monterey: "bf395e4aaa8109cb838ca97e4e7a913750435d1afbbb0c7443bb51cb640975cd"
    sha256 cellar: :any,                 arm64_big_sur:  "6268f35bc703c7c0c48ea8e19f77a981d165f7b833bd681eec57a38dc31f1401"
    sha256 cellar: :any,                 ventura:        "067bec8e3ec8e9c8998c572656a63e8ce21be5a9a5f17d7ec981a5c9f77b27f1"
    sha256 cellar: :any,                 monterey:       "9361e9b0a498a79fd3053776b3e65672c105cec03210a2cd8a5a9d823a511c84"
    sha256 cellar: :any,                 big_sur:        "e7a927f2a59c15f964f984fbf8d13a6825ee9424901e6b8763b7ff56c5c66731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4842f2a98e88fda3c1ff47c600af886df86d2567f99a47cecd8ba68c46ce4498"
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
