class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.9/libtorrent-rasterbar-2.0.9.tar.gz"
  sha256 "90cd92b6061c5b664840c3d5e151d43fedb24f5b2b24e14425ffbb884ef1798e"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cadf2d073d63924cf3b8067eb418068ef8b1e4b6376490f71dd96d2ddd4db5d0"
    sha256 cellar: :any,                 arm64_monterey: "9e73a3610d3f2d0d170d356b8395fdb007f57fa9f825a36ab131c302eb6cb3cc"
    sha256 cellar: :any,                 arm64_big_sur:  "d342c8cae880eb64b5ab591128715831035bf1706868653329a97b22fd2cae4b"
    sha256 cellar: :any,                 ventura:        "a28da91f5c7049e531b605411ae2e1f4e27ebff69e8dcb5027ad694be87f8aa8"
    sha256 cellar: :any,                 monterey:       "8ccba3fe9bb79b036939f0c1a1a84d4e3f038a9d3f82b573e4f39d3c94316795"
    sha256 cellar: :any,                 big_sur:        "7e2945c40d84b768e8e09ea5c55aea7daec901f1bf1ec9922aaf656831df14a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a16dc507f748c4dcb42c9509f4e431c63a0b79468b0aba2e7572dff3132c0ba5"
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
