class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.9/libtorrent-rasterbar-2.0.9.tar.gz"
  sha256 "90cd92b6061c5b664840c3d5e151d43fedb24f5b2b24e14425ffbb884ef1798e"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "86e523fc8cd5fd49599171295c4866b6ad14d6374ad46a495b8cda6d38e2d098"
    sha256 cellar: :any,                 arm64_monterey: "5678eb2ed0b5693f3316d9ead4a4485bf295f7d49d8a94d031f949fccb7902c6"
    sha256 cellar: :any,                 arm64_big_sur:  "9d36a8ba83f84e6712f9d4390934dedb36060b4511207524a2d37489595d42cc"
    sha256 cellar: :any,                 ventura:        "f857488d501e6d047043532584a75d9f526d4be2b2e6c1a88313ac38078de700"
    sha256 cellar: :any,                 monterey:       "67361c2f8ae3c68f044bec1a2552f94bfb46f79ae33b1092b921b82010ab6e6f"
    sha256 cellar: :any,                 big_sur:        "1c2c548868767ed00f74abdc585e099941c489ca0f4a67fe1de3bb2469f09ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab8611e0547f2c6378d2aab25616ae23baadfed0f259691ea407d14d0fa173dc"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
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
