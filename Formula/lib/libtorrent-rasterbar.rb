class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.11/libtorrent-rasterbar-2.0.11.tar.gz"
  sha256 "f0db58580f4f29ade6cc40fa4ba80e2c9a70c90265cd77332d3cdec37ecf1e6d"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00693fe717a3800ed4d6251cd19cc29834e8d55bd68124ce0d5dcb9f5ef3b1b7"
    sha256 cellar: :any,                 arm64_sequoia: "2ce931771a0e204ab86b0f2cad6ab21a7fbd4739523be7614083056d83681876"
    sha256 cellar: :any,                 arm64_sonoma:  "1e7c95c935dc4b8df3aaf6119b16fbfd4aac0f6a502bb22cc13d9f64694bd369"
    sha256 cellar: :any,                 sonoma:        "0325acefb705f5c27fb7b40153304ebc513976c17cdcd5c90b99ff83242de6ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d66a67aa87689f618f972e8764dfec8075450cfbc5e8706254e32ef65049a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "247594ddb1b34948f45acc2e02b7c3ed1f6d68d79d5048cd98da9759675bcf35"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.14"

  conflicts_with "libtorrent-rakshasa", because: "both use the same libname"

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
