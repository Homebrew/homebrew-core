class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.11/libtorrent-rasterbar-2.0.11.tar.gz"
  sha256 "f0db58580f4f29ade6cc40fa4ba80e2c9a70c90265cd77332d3cdec37ecf1e6d"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a9c70f259f11ba3f9f2fc25c2c33d74e8d12fd1ac3a8e70304f0cd9c8040050"
    sha256 cellar: :any,                 arm64_sonoma:  "a9b2ca32ab12c5ed9a32648a9a401e1a26817105ed230d316453a939358af039"
    sha256 cellar: :any,                 arm64_ventura: "2e3102b5a138e1b6ba5f30f9575f5f66a7f02d4c3df67c71c533dc7b7627be31"
    sha256 cellar: :any,                 sonoma:        "e78bb84c2382e17ffb242f67df0a359ea5282d12bd97e451034b8a32467a559f"
    sha256 cellar: :any,                 ventura:       "1c3af891fb78a3d5340f819a14692e2eab6e91cdc75dced3f291fa4592c3c9a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "819d9bc5e7ff5c393317e975a2db40264a67093913bc3332f4b67ab1914718f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79d40134bb9381e74e9e8d3bda73778535bdb4f816ae7e87c0e9df53409ae6c6"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.13"

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
    assert_path_exists testpath/"test.torrent"

    system "python3.13", "-c", "import libtorrent"
  end
end
