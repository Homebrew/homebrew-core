class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.1.3/libtorrent-rasterbar-2.1.3.tar.gz"
  sha256 "de05681acc564651211b4351af7d633a7a225587f0604611d657729dec299ae6"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_1"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "0168c0d9756d225c89ba3a446153ed68c1c3bdb895683cf55b6922edb6601b1b"
    sha256 cellar: :any, arm64_golden_gate: "b8c5d2a81f2282d0286623d97d5840225fb33f9f22a6f72b51695577dce03d1b"
    sha256 cellar: :any, arm64_tahoe:       "c2250c992f63e20bb6464dfa4e6f001c982d4fa264bd57c0da3b0a616b9b644e"
    sha256 cellar: :any, arm64_sequoia:     "dbe631a93891dfa71f2aef3bbd4b9f017834993d0107e398c7bf7447c59a3978"
    sha256 cellar: :any, arm64_linux:       "89ce8c76a6b70d777cb820f13908ef0b2577242c4d50e63e69594b477cf47bc1"
    sha256 cellar: :any, x86_64_linux:      "5d851afb01d68b912484172ceb5d677db5f981dd02813526a6e244129d49a9ac"
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
