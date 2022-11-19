class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.8/libtorrent-rasterbar-2.0.8.tar.gz"
  sha256 "09dd399b4477638cf140183f5f85d376abffb9c192bc2910002988e27d69e13e"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4abfbd647e31d5ca3b55ecae68c6921ea0b1926b6d57e289937d7047d5598b39"
    sha256 cellar: :any,                 arm64_monterey: "bea1cf7805d23a451fdf9087599bbf011b715bdeafa8a99598f86fe6c68cd159"
    sha256 cellar: :any,                 arm64_big_sur:  "df57c588b01ac1f98038b1fa630324679eeef9ecce9993402edc0e7d27cc19c2"
    sha256 cellar: :any,                 ventura:        "2f82c5f46d1fc53023512b6a586d44614bed7e1c93f7b3bbe98e256e2ed108b7"
    sha256 cellar: :any,                 monterey:       "92ff4873b0b05ba31f69461a960000df03a979ebf0f5a82fbdc3259b2f768f30"
    sha256 cellar: :any,                 big_sur:        "7c2983874b95ee31263a22006d4c80ae6b89db638a71fd079f1179fa1e21f603"
    sha256 cellar: :any,                 catalina:       "fc5249a347e431de82c2658df82c407eebb2df7c626499237167a8d050e3eab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d950082ac7b30b4c61fe85335967857d09504d42a535315eecb53904ca1cd0c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.11"

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

    system "python3.11", "-c", "import libtorrent"
  end
end
