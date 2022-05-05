class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.3.1.tar.gz"
  sha256 "ab4a94b9bc5a5ab37b14ac4e9cbdf113d5fcf2d5a040a4eed958ffbc6cc1aa63"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7322dd79d65890819e241185cd1cd3506cfa2211f92fe4ada9c8d39facd488ad"
    sha256 cellar: :any,                 arm64_big_sur:  "279b44ee7ae6b7773f6358372a6263aaaf256830ae2bebb4ddaaef88a718e11b"
    sha256 cellar: :any,                 monterey:       "b9429c4305b6919a9cd3c3aca48568b77e6eb9d42af38a38b1c82fe39b30a392"
    sha256 cellar: :any,                 big_sur:        "b6e164c772de6af9b710a9f356af577743e0ccc4090b20597f68083d277dbc09"
    sha256 cellar: :any,                 catalina:       "1cd495d392e6759e860a6801a18e309b3efd9e8b472d3f2d677e8a8acc425a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f76a247488587d992312c7d4b7fa60c3795cc92b4e93efea79fca8717b75883"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

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
