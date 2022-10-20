class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.7/libtorrent-rasterbar-2.0.7.tar.gz"
  sha256 "3850a27aacb79fcc4d352c1f02a7a59e0e8322afdaa1f5d58d676c02edfcfa36"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c711acb06da5040aba3611ad85aa8294eee3fb549e785f96d1ba07071b3648bb"
    sha256 cellar: :any,                 arm64_big_sur:  "7e3322911af00f6114db45788553f9330f4ae118595a67be8239a0bb1121c917"
    sha256 cellar: :any,                 monterey:       "136f3f3edbcd98fe5f33af3500c9da09c7d3d7270907d8ae8662aa68767b80ee"
    sha256 cellar: :any,                 big_sur:        "16d60e481f6771f2e979d017b77ec648a9937ce98819b0783d116843a82dcc8b"
    sha256 cellar: :any,                 catalina:       "89b78310853a90faaec0c5ebc12518761a59c6c0c1cce4a29175e35aefcb8fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f3a549e3dc34444b55ecc0744eb35d46a12bc370d4454a5243fd048eb573fb4"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

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
  end
end
