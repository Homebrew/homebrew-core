class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 24

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e497f7f3b14631af61cc19b6db85c1657adcdddaff36d65e1e09ad602680b51b"
    sha256 cellar: :any,                 arm64_ventura:  "beca55c2ed09f756294e16356e9de98567965c61560387bdc56c1ccc2abd8486"
    sha256 cellar: :any,                 arm64_monterey: "3917c61cc29c6791825f62926bbc9b306b13f3ee2f472d1bc9985a855f51315b"
    sha256 cellar: :any,                 sonoma:         "782c24dda4a0e5c549c72300476208eaeb1650a4a2ca4eef067e445177048f65"
    sha256 cellar: :any,                 ventura:        "42d735f79f81c0cc479fe0cf7848ba6c2580e83493126551d52e92e640dd96fe"
    sha256 cellar: :any,                 monterey:       "6039477a5fbd8a4bdc5326542cd3681129232827b1ad8a6775eb6d51ce1660cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e2671ed2fd9402f9d6d39a14bba7b9c3ad4b35abe230e4a6da4307b8eb2f1fb"
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
