class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  # Remove `stable do` block when patch is no longer needed.
  stable do
    url "https://github.com/arvidn/libtorrent/releases/download/v2.0.5/libtorrent-rasterbar-2.0.5.tar.gz"
    sha256 "e965c2e53170c61c0db3a2d898a61769cb7acd541bbf157cbbef97a185930ea5"

    # Fix build with Boost 1.78. Remove in next release.
    patch do
      url "https://github.com/arvidn/libtorrent/commit/71d608fceca7e61c9d124f9ea83f71b06eda3b17.patch?full_index=1"
      sha256 "20b8e93b67f81af22e50bd668fbeee30147dd85d3ffdff9d624531c32f54e567"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ec36596076e63e4d4f7c3d04b62aee6f8b0f729ba32758fe364753f859b31f44"
    sha256 cellar: :any,                 arm64_big_sur:  "09e94f3fede7ef026dfb8977c6b883fd6ab5f24aac319b8dde461149d7c0e531"
    sha256 cellar: :any,                 monterey:       "62cb48b0aa76dce1afe071b65a8637d6d6275d13eead3450aea1065879260d92"
    sha256 cellar: :any,                 big_sur:        "48c7b32a652eacbb59d5ed4948ecc686e76fe52f00a5e49463100d7c62227350"
    sha256 cellar: :any,                 catalina:       "74d9cee17029faaaf3c858a9c167bebc7756a55378450bde41f6f78c2154ec86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0a25a4299d4dda53f7485eac44dece7244a9a652fa3f8e9593e31c3bb427f56"
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
