class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.9/libtorrent-rasterbar-2.0.9.tar.gz"
  sha256 "90cd92b6061c5b664840c3d5e151d43fedb24f5b2b24e14425ffbb884ef1798e"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "670a683847ea2279e470ab61277245f6b0c6d68d3cdc09950be3873571b59460"
    sha256 cellar: :any,                 arm64_monterey: "141e9c8acbb0bd7ec26e87f75ed9679e5aba3af8cf173b737074befe96bcaff6"
    sha256 cellar: :any,                 arm64_big_sur:  "ef711aa28e566c0f85c762189b35fc91e2531876b098431ef73c652fe202e227"
    sha256 cellar: :any,                 ventura:        "732367fa71fe0c1779649c6ad3f4f0890b1ac8d84e0f498893ddb114528d5bbd"
    sha256 cellar: :any,                 monterey:       "6e67ba5a93eab450608da8638b77f96728108a63378eb9f19f5f5a4baf59b79d"
    sha256 cellar: :any,                 big_sur:        "f8005ff65fddc6ccac6a80da1b11e18f64276b947c1ea075c276facfe3dd38d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa4b6300b65714f8e10c259b203350f9fe787db3d6a479f46110e31fd26b3c06"
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
