class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 28

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "82e24161bc34248337ba4f6f8cbc044c1ea4d7a84b783e57870e00ad7882cdfc"
    sha256 cellar: :any,                 arm64_ventura:  "35545cb8b6898c8f12be02e42322f4a30353e124f9665b754f6b191db516b6d0"
    sha256 cellar: :any,                 arm64_monterey: "400668748b95f3442f311564dc9b39a5f8017aaf8e2b1dd17191c89c56bf48db"
    sha256 cellar: :any,                 sonoma:         "b7bbb579e34ad75f5b874edd2a3b0182aef23fab7b31ad6033330821fc0510a8"
    sha256 cellar: :any,                 ventura:        "bef8053887609aba4c0dc914d2b5d58d7b4aa52e4e1f89476be9048585c46b66"
    sha256 cellar: :any,                 monterey:       "f778a8053e862bfc3b555b7a0b3c18e933b8c834e24ee827fcc180a3904288f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78802ebc7f091e21721e9aaf4621e61ca34883153173993a0c25a3b342b177bb"
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
    %w[abseil-cpp capstone protobuf re2].each { |dir| rm_r(buildpath/"third_party"/dir) }
    abseil_cxx_standard = 17 # Keep in sync with C++ standard in abseil.rb
    inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD #{abseil_cxx_standard}"
    inreplace "CMakeLists.txt", "-std=c++11", "-std=c++17"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end
