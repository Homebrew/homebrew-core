class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.11/libtorrent-rasterbar-2.0.11.tar.gz"
  sha256 "f0db58580f4f29ade6cc40fa4ba80e2c9a70c90265cd77332d3cdec37ecf1e6d"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f692d49dcb233d376a1000efa5bc05ad6f32ba62524234b83e8ad02503f91a5c"
    sha256 cellar: :any,                 arm64_sequoia: "881f37561f4db105dd4f473a8b70bcdafb79a5ef22d682d016f781be379702ff"
    sha256 cellar: :any,                 arm64_sonoma:  "2be44ee8233fc816fb9fb6f3adb5d9814b65c777428bc2f275f6753c45f6b53f"
    sha256 cellar: :any,                 sonoma:        "2f0f3c4502ee5ef4e45bd2d1ba32400cba06a6ee33a9547994e0889d34398bf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ca014535509265c7d546afdbc1865aa628de9a5b9d79fc4ca16832101ef448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a43959bb1adf82af9394834006043c3f47e7a4f0cb81beb74b354f04a80bca"
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
