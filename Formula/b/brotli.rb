class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/refs/tags/v1.1.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/brotli-1.1.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/brotli-1.1.0.tar.gz"
  sha256 "e720a6ca29428b803f4ad165371771f5398faba397edf6778837a18599ea13ff"
  license "MIT"
  head "https://github.com/google/brotli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "b6e6ff18746910c7d7bf229595c622d04672ed0b5ac015c87e806ae026e10eb8"
    sha256 cellar: :any,                 arm64_sonoma:   "2a95140d61198e3153ff27d8847b76dd34162f6e6e39f3e0f34d2b3a3e4f15dd"
    sha256 cellar: :any,                 arm64_ventura:  "8065a97a2022d24617de5ae2a0e3588187878999b0ece3aad79e3bb7c8735772"
    sha256 cellar: :any,                 arm64_monterey: "b692b610d85f31b272548c0f0e26d1af9f7e98cd9223d6e14e64b8585ef6dcda"
    sha256 cellar: :any,                 arm64_big_sur:  "a9356d6162ffd085ed43eee73a5176d330e21c087409ec44cd562e2225f6eda9"
    sha256 cellar: :any,                 sonoma:         "deb010485b7e58ffb00f45db61fa9b1ab0690c6b558d36755740fd4e62cd9400"
    sha256 cellar: :any,                 ventura:        "8102401653fe365896171eac88f20eefa5295ec699555af7275efe144f5e877d"
    sha256 cellar: :any,                 monterey:       "befb6d59eb07e6efac5d321e3fd70e9763baa1e89028a56b504685974c5c9d8e"
    sha256 cellar: :any,                 big_sur:        "b848f83229a3242e0d629a243d275d0c6a03f1b6816a28d83d96990bfdc4604c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a2e1cc12312a092b38e79952fd2232f564f2c64cda0f69e97a55c65df9b29ab"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--verbose"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system bin/"brotli", "file.txt", "file.txt.br"
    system bin/"brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
