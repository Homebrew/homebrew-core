class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.10/libtorrent-rasterbar-2.0.10.tar.gz"
  sha256 "fc935b8c1daca5c0a4d304bff59e64e532be16bb877c012aea4bda73d9ca885d"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "083da8a4b3e019eaef7ffd709997fb6c92ee53df2cc591cf8f9f0aa5705efa9d"
    sha256 cellar: :any,                 arm64_ventura:  "e88fd0649c2686c8f95512bec975ac087d4958afca95457e1ded37cf7ffbd2b1"
    sha256 cellar: :any,                 arm64_monterey: "f5688e8d472c9630c3e1601e42baa1c5c3b2181fef3dc3abafccb165c7b6f4cb"
    sha256 cellar: :any,                 sonoma:         "df802493e5152798287eff0136effae05d4b540f85c9173b450e6a3e0458262c"
    sha256 cellar: :any,                 ventura:        "d951104198128699a7f65163433785a92780378271bae636d815864f655913f9"
    sha256 cellar: :any,                 monterey:       "a851b4630ce03752d506533f0cff6e64c76ae4ab1e5373975fd77359f78d959e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a14895b31b7d495bc70eb02909c4c1a9c192be5faef37697b09d5197904e09a"
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
