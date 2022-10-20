class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https://github.com/udoprog/c10t"
  url "https://github.com/udoprog/c10t/archive/1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bb52335803ba6ede73c4108d60521408261467674625dcf300a847aed813fab3"
    sha256 cellar: :any,                 arm64_big_sur:  "2ee23e4a9df8e49fea71796878b496e17fd85f708366cf7776706dcbcd7c5ffe"
    sha256 cellar: :any,                 monterey:       "69fb50b752d67060a557c23274bb83bfe73ec3a76a09988cf78646371d6abbf2"
    sha256 cellar: :any,                 big_sur:        "59e476e2c75735742d2147673a668bbf24e148383192b4ed8002f2e1222e90b6"
    sha256 cellar: :any,                 catalina:       "412f8b7ad24cd8ed63c2812c1ca4332ac4b3c159784e5dea36462d0a5dc3c41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5051fa40ffa44dce21c9707b05a027164b5b3747a514ae424f671ecc5461589c"
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
