class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "7980c77acbbf460d6de7df1d30b2f2d9da550db1512d0e828623851c687b238a"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4cd52230b1216d6acef0934bca869eb23747a44209cc2da04191c97356bf5ba6"
    sha256 cellar: :any, arm64_tahoe:       "43029b1819d7e6a373bd2280387982a6c02c9421cc5104042477687f535249ca"
    sha256 cellar: :any, arm64_sequoia:     "01a61cb2c86972c45dde929b7cb24412a6964ec4ee1cfe8c775d7879e5e369ef"
    sha256 cellar: :any, arm64_sonoma:      "b125a0f6c67d15d90035ac32a75dfa94a910ec057549b1da4a1c053c3f0ef2dc"
    sha256 cellar: :any, arm64_linux:       "30a27759d711597426727f060ae0a24cf601f81ae2408c4d9fcf47e96ed941af"
    sha256 cellar: :any, x86_64_linux:      "5e7a7447a8be61b59459b52868df6dbc3a97458e48aac84456f7cff1ae040156"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "protozero" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "expat", since: :sequoia
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DPROTOZERO_INCLUDE_DIR=#{formula_opt_include("protozero")}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"input.opl").write <<~OPL
      n100 v1 x1.01 y1.01
      n101 v1 x1.04 y1.01
      n102 v1 x1.04 y1.04
      n103 v1 x1.01 y1.04
      w200 v1 Tnatural=coastline Nn100,n101,n102,n103,n100
    OPL
    system bin/"osmcoastline", "-v", "-o", "output.db", "input.opl"
  end
end
