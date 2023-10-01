class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 17

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3fac406a0ec1ca79cff005abbde0b2eb3583e12437b16416700aef4a71465d09"
    sha256 cellar: :any,                 arm64_monterey: "9df61277d6cab0d016289b488df9cab8a1ebb42be9b081665d6f72669db86d75"
    sha256 cellar: :any,                 arm64_big_sur:  "1eaaef8d8e5370cfa247e89a311d46a23f669fb6f62613cd2c04ad33f8546027"
    sha256 cellar: :any,                 ventura:        "38ebaaa88f32202facfd508083f9000918f51b4f25bf64331f62a2f9b5d1f5dc"
    sha256 cellar: :any,                 monterey:       "241b3a651e3cff5bd4a26bb807f865e4edfcb3f6cae36f1e1d0e6d6102391f1a"
    sha256 cellar: :any,                 big_sur:        "3f25a3ffd9e738dbdc7492381094fcbe97ce8ab87af95a6dbd4415196dfb3db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f167593af47fcc2a92180def23e4580a2071296d63fa471a4f69d1a495ce0b81"
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
