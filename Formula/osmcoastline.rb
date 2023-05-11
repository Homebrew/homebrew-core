class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.4.0.tar.gz"
  sha256 "2c1a28313ed19d6e2fb1cb01cde8f4f44ece378393993b0059f447c5fce11f50"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "269ea3be14f5395ed5e3d453937ae693470c3594e2d7389fb3180dc7e08b6c80"
    sha256 cellar: :any,                 arm64_monterey: "17174749a13c700e3ae41146e6d69bda6ff5d8ee53be2f31c49fc9de602f3878"
    sha256 cellar: :any,                 arm64_big_sur:  "1072decf9e48f16fe2583bed1c0f1044a2cf7e8bb9433820bfa2c9c123f7f2a2"
    sha256 cellar: :any,                 ventura:        "04618e0e1ceed887d6cc7d5f8fb6ac601fa7cca7da3448ce22beeab44caefbd6"
    sha256 cellar: :any,                 monterey:       "c914fa3fe6a150e9b9e3ffeec02efc4d27fb6617c88367ccfc1681b7ee56c5db"
    sha256 cellar: :any,                 big_sur:        "481e2ac605a060679dc8472f68ccb01adcee971c5c8f00e3926014eb4e2148fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8026a3742b442711009fca9f49048b5c8c6e3a402dc0dc6bedc08c9f124d825c"
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
