class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https://github.com/udoprog/c10t"
  url "https://github.com/udoprog/c10t/archive/1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "87bfb448e0461b3f6854ca2d35216fcc949cd652935bf4f9ebdf60ea717a3351"
    sha256 cellar: :any,                 arm64_monterey: "235dd40d5d9aa664635c59efe22d054bdf6cc687a1e4a1e0ca43254b2325288b"
    sha256 cellar: :any,                 arm64_big_sur:  "9461253ad226e1b367b25a36f311dc2d05e0d3df58920723b98007c8f0b4debd"
    sha256 cellar: :any,                 ventura:        "2dea1e71d21eb4dbd242bfe9f210702c42345b1ee2e27818731827d5ee136136"
    sha256 cellar: :any,                 monterey:       "1b4a0b97ff0ba51123c5f5c31d5105e7d3965a57e056e35ce17dd6330eb19360"
    sha256 cellar: :any,                 big_sur:        "9f4137cb46c4712d4fa2f9f4af3d640e0469fe12bb24aa402cdec42ea328ad91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "109fe3090ead8cd3194473afa380872eae1f88e72304741d8b1c3340251fe044"
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
