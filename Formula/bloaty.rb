class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a908f8aa9b2ea97347699085477792f1d435a183422ea0603aacf998987f92ec"
    sha256 cellar: :any,                 arm64_monterey: "c1afc7e9983ec8f1dce582c2c81f9062e8c0a56ac123cb4e7302b08f9532526e"
    sha256 cellar: :any,                 arm64_big_sur:  "1fbe4531235432a37e659cdbd2fc20346debaf760bf0e588e05a4c718b7fc128"
    sha256 cellar: :any,                 ventura:        "912b57b20bbd7382fdb4e8cedd7eb1234aad2cd5f4e8350748503addae7f1529"
    sha256 cellar: :any,                 monterey:       "3565943373a8febf808c2ffa8586fb55d19a9eff5b2e6866bb5727859ad86435"
    sha256 cellar: :any,                 big_sur:        "bb416a7971fe02b03081f8e90eaaa0da657c917d68b8dc75e1da1dcff8f85bc6"
    sha256 cellar: :any,                 catalina:       "37d9fd17332ef37c9dd255f59ff52f90f3ab83b82c44356b76848baa2b33bb9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4da1bb99c01f5add9588dea7db7db65ba677409cbfc8aaebde42c94fc63b3ec"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "protobuf"
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
