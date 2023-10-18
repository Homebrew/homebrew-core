class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 18

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "637a28eba79bd3aef262038120006a4675ca9432655392f5d12b769c1ae89f95"
    sha256 cellar: :any,                 arm64_ventura:  "000fa53d08c9cdac9608d238e30eb867ad2c609cf2ad0c6f8c4ae5aed24eb2bd"
    sha256 cellar: :any,                 arm64_monterey: "f6d7287c456de5ee5c750e361b4b60af29c9e171195054343be9710ac3a2f215"
    sha256 cellar: :any,                 sonoma:         "2453cf8f2c4c9b9fde240f4202243eb3d6d408e803301ceae9954d7908214487"
    sha256 cellar: :any,                 ventura:        "01b216cd29f7d71accc573fd2c5b7bcaa198901fa472772231edba52cb9c9386"
    sha256 cellar: :any,                 monterey:       "2ee46c0910182b0064eb2265672ca03dbaa477d2e97377d6e99aac4eb283ebd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cc539deb68014042a9ca0c8f5502cf32ba477b23dc72cb168b0c4486d97e31f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  # Support system Abseil. Needed for Protobuf 22+.
  # Backport of: https://github.com/google/bloaty/pull/347
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/86c6fb2837e5b96e073e1ee5a51172131d2612d9/bloaty/system-abseil.patch"
    sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Remove vendored dependencies
    %w[abseil-cpp capstone protobuf re2].each { |dir| (buildpath/"third_party"/dir).rmtree }
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end
