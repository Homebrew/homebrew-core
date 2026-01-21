class Libbsc < Formula
  desc "High performance block-sorting data compression library"
  homepage "http://libbsc.com"
  url "https://github.com/IlyaGrebnov/libbsc/archive/refs/tags/v3.3.12.tar.gz"
  sha256 "3d8eee9351468bdd3fb3bc28dda0e24cfc0332997eb0210ea7bd548d77c3d194"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "854969cf0bcec5a2b0f200300dcb083612cb1d88aee5b22e192acde3460fbb2b"
    sha256 cellar: :any,                 arm64_sequoia: "b0413bddefb5d23873e1b3ef62f0faa6d54b6c47bc317108f3df4f4fa1ab9ce5"
    sha256 cellar: :any,                 arm64_sonoma:  "97a4a2cfdc8a9c65d0cfc5002dc652aea7dad01daf8fa3a11bfa662b5240c6ba"
    sha256 cellar: :any,                 arm64_ventura: "72cabda9eb1df38246c1a7e42f8a1b3c6aa3b8f27e1122aa039db04929b0a7de"
    sha256 cellar: :any,                 sonoma:        "b0fb4bcf12cb54f6457c48d6c3ab4140b1f0196ed1deb018633f013cb02121cf"
    sha256 cellar: :any,                 ventura:       "85ebfb7e3ba754f0139d8e003957899adb23840cc977e2096b8d06c4e0c41061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "823338cedcf64c6f7de67238c9e71f5117011b009167301069674aeaadeb1253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a40d01db777bfa872f61fa03440755c8a5c13cca0002942b68f5f0c55e3f4215"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "bsc", because: "both install `bsc` binaries"

  def install
    args = %W[
      -DBSC_ENABLE_NATIVE_COMPILATION=OFF
      -DBSC_BUILD_SHARED_LIB=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"bsc", "e", test_fixtures("test.tiff"), "test.tiff.bsc"
    system bin/"bsc", "d", "test.tiff.bsc", "test.tiff"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.tiff").read),
                 Digest::SHA256.hexdigest((testpath/"test.tiff").read)
  end
end
