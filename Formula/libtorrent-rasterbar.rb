class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  stable do
    url "https://github.com/arvidn/libtorrent/releases/download/v2.0.6/libtorrent-rasterbar-2.0.6.tar.gz"
    sha256 "438e29272ff41ccc68ec7530f1b98d639f6d01ec8bf680766336ae202a065722"

    patch do
      url "https://github.com/arvidn/libtorrent/commit/a5925cfc862923544d4d2b4dc5264836e2cd1030.patch?full_index=1"
      sha256 "cbcbb988d5c534f0ee97da7cbbc72bcd7a10592c5619970b5330ab646ffc7c52"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "352d0452dba6d9641f1ddf10b9586354043e367ba9d667cb4ac2b8ace4eb25db"
    sha256 cellar: :any,                 arm64_big_sur:  "0e2715fe154c1579c148ca067caf1479b540d872958d46fb8461a881c9472a90"
    sha256 cellar: :any,                 monterey:       "cc7b117307516237ce4af67b81006a761b368e117d60ff8212fdb673c6c610b3"
    sha256 cellar: :any,                 big_sur:        "88f37cf149334267e04d15774fbb5547bc1148946f6f89a950c582f07591d5cb"
    sha256 cellar: :any,                 catalina:       "ac182f0d0718b814a4963406d0efd411d06c11ce201685da2c870f352a7d79e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d257713559801ce0b9838cb076222d48ac5c90d3b03c020e51334a288441fbe"
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
