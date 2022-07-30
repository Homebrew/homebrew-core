class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.7/libtorrent-rasterbar-2.0.7.tar.gz"
  sha256 "3850a27aacb79fcc4d352c1f02a7a59e0e8322afdaa1f5d58d676c02edfcfa36"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "71f49d2a6b339da7f99879697340c8c11b4ee5d006008ef427ad44357ac6babd"
    sha256 cellar: :any,                 arm64_big_sur:  "80bb116e01e4c70adbf4290280d647442cb659bdb66b84bf589d67f4a8def5ad"
    sha256 cellar: :any,                 monterey:       "b8927cbc31325e6d03aada3fff69c256a1a572bccaa852de6e76c11a4f5d768b"
    sha256 cellar: :any,                 big_sur:        "1f7cd2a3c57ba4254e9243ca79704a22ff5fae699b8cde5abee0f390da8b5cfd"
    sha256 cellar: :any,                 catalina:       "df1666bc529a90e5d2883ffaa581cc767f1b7a661922f46c6dd8012b01cee73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41daca9c42f9b5faae184ac94afe14048f2194782776f8b3454b5345d096ce62"
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
