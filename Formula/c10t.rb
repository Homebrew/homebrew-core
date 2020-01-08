class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https://github.com/udoprog/c10t"
  url "https://github.com/udoprog/c10t/archive/1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"
  revision 1

  bottle do
    cellar :any
    sha256 "50bb289bc77fc39bd7fa248be991069cfa63419c8ad74329d3684a965469084d" => :catalina
    sha256 "1bdc623e16b1854d4865ce29e7fb6e0724262ea2b998111c6ab908b5dbd5af17" => :mojave
    sha256 "ad850802e7b161e55c19bcb89d2af5a10a536574bf25a1c45a2693299d6182d2" => :high_sierra
    sha256 "fbfab463dd8a2af17bb3b8d07d448d8411f9393d98b1b35f6862a7dc92da7c82" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "freetype"

  # Needed to compile against newer boost
  # Can be removed for the next version of c10t after 1.7
  # See: https://github.com/udoprog/c10t/pull/153
  patch do
    url "https://github.com/udoprog/c10t/commit/4a392b9f06d08c70290f4c7591e84ecdbc73d902.diff?full_index=1"
    sha256 "5e1c6d9906c3cf2aaaceca2570236585d3404ab4107cfb9169697e9cab30072d"
  end

  # Fix freetype detection; adapted from this upstream commit:
  # https://github.com/udoprog/c10t/commit/2a2b8e49d7ed4e51421cc71463c1c2404adc6ab1
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/f7ab02089c43dd557ef4/raw/a0ae7974e635b8ebfd02e314cfca9aa8dc95029d/c10t-freetype.diff"
    sha256 "9fbb7ccc643589ac1d648e105369e63c9220c26d22f7078a1f40b27080d05db4"
  end

  # Ensure zlib header is included for libpng; fixed upstream
  patch do
    url "https://github.com/udoprog/c10t/commit/800977bb23e6b4f9da3ac850ac15dd216ece0cda.diff?full_index=1"
    sha256 "5275cb43178b2f6915b14d214ec47c9182e63ff23771426b71f3c0a5450721bf"
  end

  def install
    inreplace "test/CMakeLists.txt", "boost_unit_test_framework", "boost_unit_test_framework-mt"
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "c10t"
  end

  test do
    system "#{bin}/c10t", "--list-colors"
  end
end
