class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.1.0/libtorrent-rasterbar-2.1.0.tar.gz"
  sha256 "ceed657606b8df453ec5e775326e3c759a2779e1202fa04abe42ed262e7bf0b6"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_1"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7fbb29f537b809e16a8ae071b74a11a1c56e8fa41473884c9e8943bc6c2c70ee"
    sha256 cellar: :any, arm64_sequoia: "5e2f9bfc4d672fd299fe9a524a587981a4af5964305e87981d4e84b823ea3de5"
    sha256 cellar: :any, arm64_sonoma:  "814db8ca72d272c6d4a4a4c77f31d6b940d679d0aeeb8ea382112398fe97eefe"
    sha256 cellar: :any, sonoma:        "c5e3b5bcc88738aecef476568a9cce0f563174f01830921a3df083ba3514898b"
    sha256 cellar: :any, arm64_linux:   "27b773abb158cede5a929cfac531cc9938a365fdd81bf0c3b5adc00bd358911c"
    sha256 cellar: :any, x86_64_linux:  "759a94b936ba4521be53290d26030cbd7eb843c371b2e6ce862f69203e9aeabd"
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
      -DCMAKE_CXX_STANDARD=17
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DNO_EXAMPLES=ON
      -DNO_TESTS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    libexec.install "examples"
  end

  test do
    args = [
      "-I#{Formula["boost"].include}",
      "-L#{Formula["boost"].lib}",
      "-I#{include}",
      "-L#{lib}",
      "-DTORRENT_USE_OPENSSL",
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
                    "-std=c++17", *args, "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_path_exists testpath/"test.torrent"

    system "python3.14", "-c", "import libtorrent"
  end
end
