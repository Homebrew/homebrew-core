class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"

  bottle do
    cellar :any
    sha256 "5be88b30573e9dfe1beaa3b5d7ee0f6114b23a07ff9a6cc539e3a962a2a45783" => :catalina
    sha256 "fde9f093c351e8ef57e6b8df5f6b0a2faade0eee0cdddfaf3ebf5927e8fd52c1" => :mojave
    sha256 "c54b0712732e3943c2ea3ca2e0eb9b7dcfce2a9b4793a353315b7142af8c156d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match /100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last
  end
end
