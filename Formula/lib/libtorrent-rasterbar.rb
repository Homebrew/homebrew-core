class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.1.2/libtorrent-rasterbar-2.1.2.tar.gz"
  sha256 "3362546d9cd71b9e49ee6cac7d3f1f914ce9cdb217c86b63d5b22cbed0334dbc"
  license "BSD-3-Clause"
  revision 2
  compatibility_version 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_1"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6a89ef19e50b0224335d6ae76fe440e3f8d99e6f33d1ef7ec3f4e42ca0294703"
    sha256 cellar: :any, arm64_tahoe:       "f309aa3265ddbc39cabe72603df175e5c88e8faa1d410eebaf391186eeeb53c9"
    sha256 cellar: :any, arm64_sequoia:     "42a6c62e568da3d24378dfb3f81897ae48432762e54af90aca629c72ce72923a"
    sha256 cellar: :any, arm64_linux:       "674a733d7895c82e39f5834f7045d8289e2f185e1b1062637954f7cd7b038c73"
    sha256 cellar: :any, x86_64_linux:      "add3131860b21e513e6e565e7d1cd1144af9a73947298ef479cc32736a2d4a97"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@4"
  depends_on "python@3.15"

  conflicts_with "libtorrent-rakshasa", because: "both use the same libname"

  deny_network_access!

  def install
    # Work around Homebrew's prefix scheme, which makes Python's reported
    # site-packages path absolute and outside the keg.
    site_packages = prefix/Language::Python.site_packages(python3)
    inreplace "bindings/python/CMakeLists.txt", "${_PYTHON3_SITE_ARCH}", site_packages

    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DNO_EXAMPLES=ON
      -DNO_TESTS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    libexec.install "examples"
  end

  test do
    args = [
      "-I#{formula_opt_include("boost")}",
      "-L#{formula_opt_lib("boost")}",
      "-I#{include}",
      "-L#{lib}",
      "-DTORRENT_USE_OPENSSL",
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
                    "-std=c++17", *args, "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_path_exists testpath/"test.torrent"

    system python3, "-c", "import libtorrent"
  end
end
