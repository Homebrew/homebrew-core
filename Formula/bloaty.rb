class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "502cbf33671371eeece830c89a19c9e57aca462eae2fcdaf25bfc5e817e8e82c"
    sha256 cellar: :any,                 arm64_monterey: "1c3f12fc157d2088ef55a7e00c0d3c3258d73e55e360f4bdd80736c4859a97b2"
    sha256 cellar: :any,                 arm64_big_sur:  "35e6f0a2f21c8b7d01d9307da751f706a37ce9553fce03a5ee9753abb9ba3368"
    sha256 cellar: :any,                 ventura:        "3cdbe90ad31433e01a393d4084ae778971daa7f9c2bb0f67696cc70473b32d03"
    sha256 cellar: :any,                 monterey:       "9811223535f034ee9b0224a7765f8537171e65c91ff6f7c0479ed611f7d0b4ef"
    sha256 cellar: :any,                 big_sur:        "9f73e1c836be054c77f91eace2765a1cae86aec0f999839f3e57caccc04d8996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f6066b7551f8ac07311aa72092526790cda1fd05f736b57ba2f21e603418b6"
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
