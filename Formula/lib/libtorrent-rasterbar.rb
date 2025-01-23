class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.10/libtorrent-rasterbar-2.0.10.tar.gz"
  sha256 "fc935b8c1daca5c0a4d304bff59e64e532be16bb877c012aea4bda73d9ca885d"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5af2be6ca4203b36c5b337e7470091f779b77bd1e17fcf75deed3d6b9445033d"
    sha256 cellar: :any,                 arm64_sonoma:  "4aba2487206f297d7f482e158a0badb442426581d37d0ff2ad2803ec750108b9"
    sha256 cellar: :any,                 arm64_ventura: "4f39f64605495692fca8f7dfee8b553e71f07693e33a480605467fe404eb5fb6"
    sha256 cellar: :any,                 sonoma:        "54520503ffad8f295f75a4eec1810a3fb9453d5dccc6486f2d7e4cecaa465a7a"
    sha256 cellar: :any,                 ventura:       "0196042e05312915abe5514e936f0e213d9bccea05cfbe2bfccbf1072862eb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18c8434cb42eb6a711424799d7752b319f59bf86761ef0d7c99e7d9930499019"
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
    assert_predicate testpath/"test.torrent", :exist?

    system "python3.13", "-c", "import libtorrent"
  end
end
