class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.7/libtorrent-rasterbar-2.0.7.tar.gz"
  sha256 "3850a27aacb79fcc4d352c1f02a7a59e0e8322afdaa1f5d58d676c02edfcfa36"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dd1dc2a54c6342429f965f3f3537e09ab9e18ba139124e049772199afcd25461"
    sha256 cellar: :any,                 arm64_big_sur:  "b88584145df91d1b1e6aa7f2e4f06cfee6e36bd005c30b331d823c6e6e78c1f3"
    sha256 cellar: :any,                 monterey:       "e53ecdcd88a1034d7d1545477a1264bd392570e68ad19c0fc20d9fe2711c703f"
    sha256 cellar: :any,                 big_sur:        "73dd5ca5761d81cc96ea6046e323879e7b7f81296deabb58664499f696dee87b"
    sha256 cellar: :any,                 catalina:       "7257ac59c530b06f2fa48f26b8e1580ae480c40c6af6826955985b57b9acae3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed2dc5e2e3e1f4115b66c6a24bf779e37e8d2f17854dac20bc0ca3d7dc2b9939"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

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
