class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.3.0.tar.gz"
  sha256 "b08ddcc8cb494a19cbf4d9f1501c47443fe374a4fe171e6f55c730ca1e710689"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "484435d2e38ed650ac0244a4de44a1ab857db1f25f2270fa2e4809fb8873d24a" => :big_sur
    sha256 "c3777d42b345383e5a4949bc00b388d71a6b5e20695cc959bfd958d4b07885a1" => :catalina
    sha256 "6830542a881dd0b7aedd8af1a9c9d62b882d4f4e3eff66929a31e5592e23ea8a" => :mojave
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
