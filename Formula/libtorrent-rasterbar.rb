class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.6/libtorrent-rasterbar-2.0.6.tar.gz"
  sha256 "438e29272ff41ccc68ec7530f1b98d639f6d01ec8bf680766336ae202a065722"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "47b1906d8e53bc2976aab0a24ba6591c17a1d5edce6c04a8f417f9da840e7d28"
    sha256 cellar: :any,                 arm64_big_sur:  "412f0df0d375a88c515e488cfed96fcea33e2294cce70b20f8811bf5759c65e4"
    sha256 cellar: :any,                 monterey:       "a64cb513f3dc2e5ac8f30caffcfc2cd699e5e7788905b7562ebc5998e7114f25"
    sha256 cellar: :any,                 big_sur:        "2f9dc1705105ea69680464d72dedf4ca7f09a4a5c88920fe3704b9f798375a58"
    sha256 cellar: :any,                 catalina:       "0150bdc3871d41c0d7a88d00789f7caba0bf597da223ab753fca87ab0877e484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ae32cb094aa1897be7be0caa2173ce260778c0955cd5493095eabaed5917932"
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
      -DCMAKE_INSTALL_RPATH=#{lib}
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
