class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.11/libtorrent-rasterbar-2.0.11.tar.gz"
  sha256 "f0db58580f4f29ade6cc40fa4ba80e2c9a70c90265cd77332d3cdec37ecf1e6d"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2984c5203e576edab8c2d51eed48c8186cda66da1035fd081d29062d705a9a2"
    sha256 cellar: :any,                 arm64_sequoia: "28eec45e51c69329ddc0575f07bb52c7f63bea43824280be5ddbb401a7830a85"
    sha256 cellar: :any,                 arm64_sonoma:  "09386b394de1c44f1c2868b700861d4c7f0974ca2c3a96fb88a4ec4ee6f85228"
    sha256 cellar: :any,                 arm64_ventura: "801ceae544984e0ebaca8e8f088e406156465f6bd980626ae21eed912a427dbf"
    sha256 cellar: :any,                 sonoma:        "321c9833fbf1a264af1378c2ed51df5532c17cc244bf98a974e9cfbe02499cc3"
    sha256 cellar: :any,                 ventura:       "bccd7da0f18e035c1319f768dfcde1ba675f3ba5188a2fdbc99bbf8eecfb8bb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55c6d36fd7c258d391ab3651210724e4a47629383a0fd8e843faa53593b7663b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9acff327ffc9166f13e06cab2739d08570e2ed62d29f1237546824c038432875"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.13"

  conflicts_with "libtorrent-rakshasa", because: "both use the same libname"

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
