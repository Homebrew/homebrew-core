class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.9/libtorrent-rasterbar-2.0.9.tar.gz"
  sha256 "90cd92b6061c5b664840c3d5e151d43fedb24f5b2b24e14425ffbb884ef1798e"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "049a4078e90bce2630648e23b96ffbf27908cbed81f3462fd82e160e37389251"
    sha256 cellar: :any,                 arm64_ventura:  "9e94940d234f88f8bcf859415603cd5e869163484cf19d01a24850b51b9e0dbc"
    sha256 cellar: :any,                 arm64_monterey: "0457a593d03f2835c00b2bc53701667ec92e920be70f7c7b947216d22937a336"
    sha256 cellar: :any,                 sonoma:         "78837fbed8f9a9538e6cf1d3dc4c77947aeb387cf1f9b15bd305c5f58519ce19"
    sha256 cellar: :any,                 ventura:        "986f695a6a217723b2dd4a0a771ea3a1e18f0a7b0c99280b06699fded71c2bed"
    sha256 cellar: :any,                 monterey:       "8a81e6f0a36693b998d600b51a99541f33a3e7c779ab24a428295eaab869d92a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c48277d8111b46da56df6994f19311498e36acf0dca2ac23dc9690875e371f5e"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.12"

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

    system "python3.12", "-c", "import libtorrent"
  end
end
