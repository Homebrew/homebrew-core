class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.3.1.tar.gz"
  sha256 "ab4a94b9bc5a5ab37b14ac4e9cbdf113d5fcf2d5a040a4eed958ffbc6cc1aa63"
  license "GPL-3.0-or-later"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d78afe585f65333a9ff766dfb3104f118868e64eeec399632affad9a2c688262"
    sha256 cellar: :any,                 arm64_monterey: "638c7caa9c37e2ed63558057d282521729cd4c58b75c4f89f69ea2dff1801f34"
    sha256 cellar: :any,                 arm64_big_sur:  "ca0613b0526f13e09f967ad27ca64365edfbf272de4a4cd8489feae0eaa293d8"
    sha256 cellar: :any,                 ventura:        "3d4528bea1bb58c2bc172e02d5bf4765003cebde8b8bcd01e3c64d452b3f119e"
    sha256 cellar: :any,                 monterey:       "4c8b9f4b83ee2bfee860ec28e7f0a6e1b514358916faf1837bf6070c35c3a8c0"
    sha256 cellar: :any,                 big_sur:        "6d2fc232874dd74f3430a044cbc05f1e69c05652a1ca33afb43946e7ac5f7c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "735fb310d46ecd1b6a28ab1d43199d3cd374de715040fd46f7d6d22fd9672042"
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
