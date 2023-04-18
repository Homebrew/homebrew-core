class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.8/libtorrent-rasterbar-2.0.8.tar.gz"
  sha256 "09dd399b4477638cf140183f5f85d376abffb9c192bc2910002988e27d69e13e"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "90e440fe5fa55291c9765e645833906103cc8375adc3e3b70c6d95b1aef11bb7"
    sha256 cellar: :any,                 arm64_monterey: "e50606d0705530b6ef7c09e021e7696a5174966b729cb30c4a79a4d1e3f261d6"
    sha256 cellar: :any,                 arm64_big_sur:  "8d2cb9917a3e77eef52e504db858ba677bcfa032d8648d75f0f4b91612b2dc7a"
    sha256 cellar: :any,                 ventura:        "4a47b58565d58d79f895f6a2046e4c6f1ae155512289aa4c8597ae9f8e93c298"
    sha256 cellar: :any,                 monterey:       "327d7149976cce2526be9c2063da421a590e4960872f9a273cdaaf8ab50ab216"
    sha256 cellar: :any,                 big_sur:        "727b8fe235c2410885590a7d3cc1f75b27eedab9252d04bf6a38948dc13e50eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4553a944cd871c7db3934aba1b15be13630d2849f3b7932c80203c1c35a5eca4"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

  def install
    args = %W[
      -DCMAKE_CXX_STANDARD=14
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    libexec.install "examples"
  end

  test do
    args = [
      "-I#{Formula["boost"].include}/boost",
      "-L#{Formula["boost"].lib}",
      "-I#{include}",
      "-L#{lib}",
      "-lpthread",
      "-lboost_system",
      "-ltorrent-rasterbar",
    ]

    if OS.mac?
      args += [
        "-framework",
        "SystemConfiguration",
        "-framework",
        "CoreFoundation",
      ]
    end

    system ENV.cxx, libexec/"examples/make_torrent.cpp",
                    "-std=c++14", *args, "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?

    system "python3.11", "-c", "import libtorrent"
  end
end
