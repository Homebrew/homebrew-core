class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.3.1.tar.gz"
  sha256 "ab4a94b9bc5a5ab37b14ac4e9cbdf113d5fcf2d5a040a4eed958ffbc6cc1aa63"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eafdd4eb3ac17b514218a3c67b8f4562ada4b7cb2b8db9985619c4357855477e"
    sha256 cellar: :any,                 arm64_big_sur:  "2c6dfbe9ff1bad2df1d96f5be762aea19993d20ae33cfaaa30e1fabf47d245e1"
    sha256 cellar: :any,                 monterey:       "2d74a18bfb2dacb243fdcb689ba2a65f451bec7946472440b0325dd4b5f5dac3"
    sha256 cellar: :any,                 big_sur:        "58e35c2d3e36a65e2de913efd7d223db355d0be6bc79b8b34d0d7a6735deea84"
    sha256 cellar: :any,                 catalina:       "6f6b48082bc6f9f60cadc80a40737ffe37c24a1efb9e9f1ab6fcbf1e314d257c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93d2728b5c389580ae95892b190a103ca3950f6933a005a1d89a7d18fc2ffc48"
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
