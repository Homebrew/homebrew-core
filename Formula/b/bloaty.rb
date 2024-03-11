class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 23

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "abb1e5c8f50a7a9347904af952f061032b1bcf8d3a5ac4d9011cec4c558a8913"
    sha256 cellar: :any,                 arm64_ventura:  "f476a680b2eab934aef1c47d9fa935c59654f8f837a6a15ade86b38fa634c977"
    sha256 cellar: :any,                 arm64_monterey: "5f2b387eb82e5bd7f985dffbad41b445ea5ba97fdb6311bc55e4cec97ee52718"
    sha256 cellar: :any,                 sonoma:         "74217843640f05ef7e7d1d233ddbfa1814883502e7b0998dd87af0d5568b920c"
    sha256 cellar: :any,                 ventura:        "87b9528a41d3a4dfcff5977a0a40707739817296812d4729a18fccae20a64e7f"
    sha256 cellar: :any,                 monterey:       "cc88f22f645eca7938e29a3d1917d7a0d40f0cdb525bc64759e1183b0b137f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e835ff4c2ccdcf3ab53ae08d1eeef8d584cbd6aa6ac8ab3ae787432fc5f5878a"
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
