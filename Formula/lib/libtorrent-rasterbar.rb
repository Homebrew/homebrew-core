class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.13/libtorrent-rasterbar-2.0.13.tar.gz"
  sha256 "892cb75c06318e2420de0faf9f63a908069d3d237676e2459fd30abe0cb3b1bf"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7c6c7c569e3914d7aaf3611421c97701603b451996352c117dcdbb8dae6843a4"
    sha256 cellar: :any, arm64_sequoia: "0a20e0b67256205a28e3fba069cf0baf4a357f5702636b48e75e2aeb6240c6f9"
    sha256 cellar: :any, arm64_sonoma:  "7657759880002e58a07d247525f028efd6b3c9737827e60591db4ab336d6168a"
    sha256 cellar: :any, sonoma:        "434a92b20015be9d5cff7553c425ebce2f5cef880e95239334805ec6c49d14fc"
    sha256 cellar: :any, arm64_linux:   "93a72e3ea40c7734ca3f35dd26dbdfcb544fab8a7ceef0919e4e6c098037dcf2"
    sha256 cellar: :any, x86_64_linux:  "781c5608acb4267c8e57c50a82fc02913cc01d5b942f877fe5609c5b679f084d"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.14"

  conflicts_with "libtorrent-rakshasa", because: "both use the same libname"

  def install
    # Work around Homebrew's prefix scheme, which makes Python's reported
    # site-packages path absolute and outside the keg.
    site_packages = prefix/Language::Python.site_packages("python3.14")
    inreplace "bindings/python/CMakeLists.txt", "${_PYTHON3_SITE_ARCH}", site_packages

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
    assert_path_exists testpath/"test.torrent"

    system "python3.14", "-c", "import libtorrent"
  end
end
