class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https://github.com/udoprog/c10t"
  url "https://github.com/udoprog/c10t/archive/1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5bcb225283ff1ef1517416ea63fd4531991694f295145be2c370d1d54d9b84da"
    sha256 cellar: :any,                 arm64_big_sur:  "38cf0106eca82d542b1e3af46093b7ae8794e255352f40ce2bc380ff525088d7"
    sha256 cellar: :any,                 monterey:       "cefe5abaf716636386a488aa4567bed7de4e83427f3e3cc65dc180a933245f7e"
    sha256 cellar: :any,                 big_sur:        "f6549cf911df71c42423a42b0ea9ca7aaeabd45607c71b46cfa45f558041af6f"
    sha256 cellar: :any,                 catalina:       "bb70f4cc507e90b5f72a44c0d0fa1a4beb500a44fd25b16681633e6521735871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbec62e6c3534ee4fd7cdb676589ca41788015dad4facbf966d5a62c637c1548"
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
