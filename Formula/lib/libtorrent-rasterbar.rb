class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.1.1/libtorrent-rasterbar-2.1.1.tar.gz"
  sha256 "0f163516ecef2e3331500266751de3098835a3c3ae0c2290448046c632bc0e93"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_1"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0fc57ac1c7e5282e8ee53d1f7669a43b83895ec5e9e01ec319fdc8588475c6fd"
    sha256 cellar: :any, arm64_sequoia: "cbd7bcc10d0f39a94ae4e840efb3d20276fed1ce35f712c0337583338ef4cad2"
    sha256 cellar: :any, arm64_sonoma:  "8d023bf7105bb19804d1687f176bb6d2d222865c23599471aa9e37f93e5b96f1"
    sha256 cellar: :any, sonoma:        "b743c21dc561aec8a7aba1fa16e22fb00c831801ba5394dabef728a33d5117cb"
    sha256 cellar: :any, arm64_linux:   "991c9397f2dabaa5165fbd54b497e5c7cc5a915bdfae0b0333a99bbe54490406"
    sha256 cellar: :any, x86_64_linux:  "e47e247a055d9d0a9fc1029f90ee38f3d7e5391430ab971ccf4ff6d8a83480af"
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
      "-I#{Formula["boost"].include}",
      "-L#{Formula["boost"].lib}",
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
