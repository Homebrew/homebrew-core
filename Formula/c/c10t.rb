class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https://github.com/udoprog/c10t"
  url "https://github.com/udoprog/c10t/archive/1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"
  license "BSD-3-Clause"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09dd4f17134af1c7713a83287ff40aff88d4453bbb3c9d4e519da8b5f0f08862"
    sha256 cellar: :any,                 arm64_ventura:  "144e7ec64d19feedfe7e3854a0897f5a5b2da0eb048fb548f1fbcdd4efa65b47"
    sha256 cellar: :any,                 arm64_monterey: "9ef90eca2b3e0ff042a64f03512ca48a48f6ed32202b01ac9600446d9ccd49ff"
    sha256 cellar: :any,                 arm64_big_sur:  "2fd469a1817d4d374970f452cdeaeec7ae048b113a32acffda510207c3c8f407"
    sha256 cellar: :any,                 sonoma:         "8e88f418693192b971244cd40bce437326a78e632d1cd475e766e22003b8c662"
    sha256 cellar: :any,                 ventura:        "9129f50c43f2d6740aa081c9746c86c6ff83b8c61ee02b2f684e5843237f5421"
    sha256 cellar: :any,                 monterey:       "c97f2ee507b1e1dbe0ce3349644c061ba512bae6fe47c4de50b70d5f928eb1d1"
    sha256 cellar: :any,                 big_sur:        "f3eebbb5b5e070925ac4b1e353e21b977b57a64b40565e4aea59b2b534e66f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c6bc31979972be1e242d28708be6a0041fb48417dd4078f0075e52eacaa2226"
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
    ENV.cxx11
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
