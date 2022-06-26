class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https://github.com/udoprog/c10t"
  url "https://github.com/udoprog/c10t/archive/1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1ab06178dd10f9525503ddde6d3cbe42a1576cf03025b8d0815ee54feffafb7b"
    sha256 cellar: :any,                 arm64_big_sur:  "f6c5c0fb2e066bc4c505d61eb9db21034a89223e5a9e47c3c2a08b17f5a431ed"
    sha256 cellar: :any,                 monterey:       "d7383bb6db139426b633868004f52d4244c96cf9fd375aedc17d17c345694546"
    sha256 cellar: :any,                 big_sur:        "15eb238ecc210202a0aa3034005b3da3637f4d5b5a7c9e6904b151d47ece6d47"
    sha256 cellar: :any,                 catalina:       "50bb289bc77fc39bd7fa248be991069cfa63419c8ad74329d3684a965469084d"
    sha256 cellar: :any,                 mojave:         "1bdc623e16b1854d4865ce29e7fb6e0724262ea2b998111c6ab908b5dbd5af17"
    sha256 cellar: :any,                 high_sierra:    "ad850802e7b161e55c19bcb89d2af5a10a536574bf25a1c45a2693299d6182d2"
    sha256 cellar: :any,                 sierra:         "fbfab463dd8a2af17bb3b8d07d448d8411f9393d98b1b35f6862a7dc92da7c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69228725cf24304d0ec95c68cb498b88aa2bb00d194a6d030f69b74613e2494b"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "freetype"

  # Needed to compile against newer boost
  # Can be removed for the next version of c10t after 1.7
  # See: https://github.com/udoprog/c10t/pull/153
  patch do
    url "https://github.com/udoprog/c10t/commit/4a392b9f06d08c70290f4c7591e84ecdbc73d902.patch?full_index=1"
    sha256 "7197435e9384bf93f580fab01097be549c8c8f2c54a96ba4e2ae49a5d260e297"
  end

  # Fix freetype detection; adapted from this upstream commit:
  # https://github.com/udoprog/c10t/commit/2a2b8e49d7ed4e51421cc71463c1c2404adc6ab1
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/f7ab02089c43dd557ef4/raw/a0ae7974e635b8ebfd02e314cfca9aa8dc95029d/c10t-freetype.diff"
    sha256 "9fbb7ccc643589ac1d648e105369e63c9220c26d22f7078a1f40b27080d05db4"
  end

  # Ensure zlib header is included for libpng; fixed upstream
  patch do
    url "https://github.com/udoprog/c10t/commit/800977bb23e6b4f9da3ac850ac15dd216ece0cda.patch?full_index=1"
    sha256 "c7a37f866b42ff352bb58720ad6c672cde940e1b8ab79de4b6fa0be968b97b66"
  end

  def install
    inreplace "test/CMakeLists.txt", "boost_unit_test_framework", "boost_unit_test_framework-mt"
    args = std_cmake_args
    unless OS.mac?
      args += %W[
        -DCMAKE_LINK_WHAT_YOU_USE=ON
        -DZLIB_LIBRARY=#{Formula["zlib"].opt_lib}/libz.so.1
        -DZLIB_INCLUDE_DIR=#{Formula["zlib"].include}
      ]
    end
    system "cmake", ".", *args
    system "make"
    bin.install "c10t"
  end

  test do
    system "#{bin}/c10t", "--list-colors"
  end
end
