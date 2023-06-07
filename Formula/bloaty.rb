class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4495349a4b0331629ac46de5a8a461836ecdd4b1a27eb5772ea5c98b4b270ce8"
    sha256 cellar: :any,                 arm64_monterey: "0f849a28b11456ec1e5c6fb584d0fb5f53dd807d561bc245d2dd4c4777297f66"
    sha256 cellar: :any,                 arm64_big_sur:  "e1420ed24daf16f96617888b99cf922f2676e1416063d99fa7e27f2210db0c34"
    sha256 cellar: :any,                 ventura:        "cd795586df3be027eca2283693b463ffaebaff45b37a39ad7487591f6ff3d9b2"
    sha256 cellar: :any,                 monterey:       "a4ce535ff5879ed2aa0f8e64b1aa0688c4cb8be53ea9bad732bfe71e7b5a6a88"
    sha256 cellar: :any,                 big_sur:        "228ff25d82384bea9cc586adcedb89d24122e3533c4ef27fb6b0e4079d304dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97b2cab488d1f284a4a3160176a4ccb45a5924459b62c4fecd1c4e9dc73d943d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "protobuf@21"
  depends_on "re2"

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end
