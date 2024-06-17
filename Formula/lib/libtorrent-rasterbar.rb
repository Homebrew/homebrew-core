class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.10/libtorrent-rasterbar-2.0.10.tar.gz"
  sha256 "fc935b8c1daca5c0a4d304bff59e64e532be16bb877c012aea4bda73d9ca885d"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28b8a4a084f0ba274048483af590aaa55150ca42162cd565045917fa3387b5df"
    sha256 cellar: :any,                 arm64_ventura:  "db4e09d346a592f040e3b929f1b7157c735684cdab2edf5405f11c358ff4179d"
    sha256 cellar: :any,                 arm64_monterey: "d0c33e201a7857339c295f580b133a9dac91c2a9f2cb4a8d3a399cddf8742f81"
    sha256 cellar: :any,                 sonoma:         "d4f9b7540d4d43631d369e38aa94ae1942de482bc0e89d0e04a873fb2376a82e"
    sha256 cellar: :any,                 ventura:        "ed6685debd92586b09bda88d139fb74a65a5a5b63c237d4cf16f44e12897b9ab"
    sha256 cellar: :any,                 monterey:       "8e4298fa146c10d50c7837d2875c07bc51a4b97e702828c867c1cffe3260c3cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07e6d4065974b21d05bce6be03f64e978ebc030829405387da152f0f17640fea"
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
