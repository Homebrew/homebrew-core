class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.4/libtorrent-rasterbar-2.0.4.tar.gz"
  sha256 "55bcce16c4b85b8cccd20e7ff4a9fde92db66333a25d6504a83c0bb0a5f7f529"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c2c117a2c0c9c2c8df372a7b8d91605096d1dde615c8fb90c4572ff8ffee4a3d"
    sha256 cellar: :any,                 monterey:      "8544e762eab85086ca9b145a6c30a2233c52d4c807f66f5ce2ab61178021122b"
    sha256 cellar: :any,                 big_sur:       "d48ce0307a32554477f8e726ac48f53452172dd53af279d418d35b47d981c903"
    sha256 cellar: :any,                 catalina:      "427766e035c86318f55b44fe60b740355ddd2f804c3ceef6a15a838857d6efbd"
    sha256 cellar: :any,                 mojave:        "a4d966bc79d6771bdebcdfd55e1f9d8455e9caa0e0d4ed72b1bf562c8197aa21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37574565f695cfe16d3c9cbc1572de7f778fbed517e5c91a13fe0aa403fc421c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

  def install
    args = %w[
      -DCMAKE_CXX_STANDARD=14
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
    ]
    args += std_cmake_args

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

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

    on_macos do
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
