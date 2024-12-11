class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.10/libtorrent-rasterbar-2.0.10.tar.gz"
  sha256 "fc935b8c1daca5c0a4d304bff59e64e532be16bb877c012aea4bda73d9ca885d"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "118ace02f7511f3ff7dadc4b98d85ed278b16eb09a50111ff60f1c9dd8ad8321"
    sha256 cellar: :any,                 arm64_sonoma:   "50532f4eedba2d57e7fb2db3ab6e5c770b8eda6b76f97d38bea9748db9872d7a"
    sha256 cellar: :any,                 arm64_ventura:  "bd03c85cb5fc01a211038dd369b8d80a322b7106673f46a8bb43d50385c36b02"
    sha256 cellar: :any,                 arm64_monterey: "4798a834da1d0a060db48116b409ac42888f73c5ea366b2b1c9e434710ee2549"
    sha256 cellar: :any,                 sonoma:         "ba11a9e2a4a9b51368ca95d5dbc4a27870f14b8db4ebc97a4a582b1b0389df35"
    sha256 cellar: :any,                 ventura:        "52d5482c3183570f5225ada003a09a07bcbd10cdc526f53517cb096112f14f90"
    sha256 cellar: :any,                 monterey:       "e3a83621f13f749b68d53b58154845be5c2b2317903301d59e509a4355cfa473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a73d8c5e133d4fe97a02b60cebea00d2e29219038d59f2ffa13f2cef46ad2790"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.12"

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

    system "python3.12", "-c", "import libtorrent"
  end
end
