class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.12/libtorrent-rasterbar-2.0.12.tar.gz"
  sha256 "25b898d02e02e43ee9a8ea5480c20007f129091b5754d0283f94e4d51d11a19e"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4255708e576d6b2c498248df030073c028cc48b9c7952bc07ed0f3affc702e01"
    sha256 cellar: :any,                 arm64_sequoia: "1c4bd2f4fa99881269417869070c3bbc40d0a2ccdc2c2f7f862bbd5178dd2cdd"
    sha256 cellar: :any,                 arm64_sonoma:  "8290140206a01587132933168b983084dce61be37b8d3b28541d7b4c61cfcee3"
    sha256 cellar: :any,                 sonoma:        "ccaa971dc8b4ad10998a0b7998a9e1fdc805196300f0827abc326e35cc821719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40e68b9edb4a76ebef6d619b69b13e70aa9951769a858ff6797456eccf182b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67709387cbaf02f41f5b5ad3088c0b23e806941e82ae5a7f4dd282fd45e6c7cb"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.14"

  conflicts_with "libtorrent-rakshasa", because: "both use the same libname"

  def install
    # Work around Homebrew's prefix scheme, which makes Python's reported
    # site-packages path absolute and outside the keg.
    site_packages = prefix/Language::Python.site_packages("python3.14")
    inreplace "bindings/python/CMakeLists.txt", "${_PYTHON3_SITE_ARCH}", site_packages

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
