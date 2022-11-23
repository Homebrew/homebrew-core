class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.3.1.tar.gz"
  sha256 "ab4a94b9bc5a5ab37b14ac4e9cbdf113d5fcf2d5a040a4eed958ffbc6cc1aa63"
  license "GPL-3.0-or-later"
  revision 6

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "dee7428e8242ab7e6028d63fd15f3319c2edfa6c6774b489a74e589d285865c0"
    sha256 cellar: :any,                 arm64_monterey: "8cf2013bade4dab5cfac258a2dc3f8f45d81a5426b7e3d43ffea2f23a6cc88b2"
    sha256 cellar: :any,                 arm64_big_sur:  "2d66f5eb8a2c12d2e05874d877ecdf65f01a850b8539c2374cf49398d21414bf"
    sha256 cellar: :any,                 monterey:       "532b6f87af7c10219e791e5fb1ee6be1fb3b4cdb3e72ae0bb7e9aa82c246c8e4"
    sha256 cellar: :any,                 big_sur:        "91fb5971b1f93694ceea006794ad55cd56be046355e0bae1b7f4200d508b8585"
    sha256 cellar: :any,                 catalina:       "126abf7580ab4ae6aae425218176ddd9b0b44a6554d7ab06c6a0f47fd8c752d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fd71a1becdab054689376a0d5c7c14bcfc557d1346818afe51fe76753171163"
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
