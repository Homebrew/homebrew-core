class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.11/libtorrent-rasterbar-2.0.11.tar.gz"
  sha256 "f0db58580f4f29ade6cc40fa4ba80e2c9a70c90265cd77332d3cdec37ecf1e6d"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40f780ae650c692d99df53473317113a79787cca8e48517bd769ef27e44897c0"
    sha256 cellar: :any,                 arm64_sonoma:  "459891957874420f4f38a2997ae4713c30ade4b585879a65b8278c6cdcceca93"
    sha256 cellar: :any,                 arm64_ventura: "cb85afdd1a230218541e8e1af0c15b5f61bfc02fe2b054ee652c1ba89d1c8c7f"
    sha256 cellar: :any,                 sonoma:        "16a6476a734fb3f71b49141ccd5293e4d0eea29e09854494ab353068ffe6f451"
    sha256 cellar: :any,                 ventura:       "d94683a3727d9d274ad6ce5d99f9deada39915fe3ed83855669fba2e878dc6a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7a3faab2197fb4297592dcfcc0bb348f2684f41296ef945cd8878bdf147cf36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6dc82f436276e95e784056c247d8926fa93d8144152359d2d4940c461602b0e"
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
    assert_path_exists testpath/"test.torrent"

    system "python3.13", "-c", "import libtorrent"
  end
end
