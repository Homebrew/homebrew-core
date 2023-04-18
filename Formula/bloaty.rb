class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "485449be09072bf5044e7a8252cf4385d3f1b4365a7907fb5cea4646dbfae409"
    sha256 cellar: :any,                 arm64_monterey: "6f7fe502951cf3d07307e67df4b5813ab9aeacf75582fbf4ae6ed9faf54defb7"
    sha256 cellar: :any,                 arm64_big_sur:  "2f1d101a8d32c7ae3a27cf35d2ba3244e9497e9d87a8d3166905ba5794d0ca9e"
    sha256 cellar: :any,                 ventura:        "6af103ce721c668c67e36cfabb7ac5ba83bb5d5579b03bb53cb75e11847ae79f"
    sha256 cellar: :any,                 monterey:       "1d3dd26f8b27220c07b0afeff8b33ee47b105362c99378f731295a3207e6e3b7"
    sha256 cellar: :any,                 big_sur:        "d5a19327b5539c53a956e006f3cca6d40227757eec2eac6d32a76f95241342d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56b54d53756f1662d6c73b914b42140c96fc6e6478555452701423551805cc8d"
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
