class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.8/libtorrent-rasterbar-2.0.8.tar.gz"
  sha256 "09dd399b4477638cf140183f5f85d376abffb9c192bc2910002988e27d69e13e"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9974bcc4c1cde22ac6bb9a546f7c516fa5b6e62165eff8a945902e35b9e9cd28"
    sha256 cellar: :any,                 arm64_monterey: "84d492d60abbc91fe14aad92b816d48e5171fd02c93797cb6367705daf5610b0"
    sha256 cellar: :any,                 arm64_big_sur:  "f4afd7c734c7b33625175069e2ba2ce4524e93422038d48fc24d9266af1d311e"
    sha256 cellar: :any,                 monterey:       "a6ab71b4425996cd4bbca800a3ee9c0be1533502fdce663e24cdaa1169259715"
    sha256 cellar: :any,                 big_sur:        "4793a194ca382421b65cd176d25f706f0befa5429d8664368ce0d6871c59876a"
    sha256 cellar: :any,                 catalina:       "fedef108cef25abf5624a948bf5f39890c68cf5347878d0c1dc1899bd6f93f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb43341a8db16d62385f965a4e0d090f413863b1aa0c3f3e90c6199c19563811"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

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
  end
end
