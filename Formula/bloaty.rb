class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "437f08da84822e2912af5db09437afb2f214df97443dd10d66c289e933fce1b1" => :catalina
    sha256 "e0eaa91cfad61274a41ffb94f335cf61ad8217e9d47eff8bb77a390d7bcdb165" => :mojave
    sha256 "1c06ab5eb36a968ba9755028760f1dfc4958273325e5d243d9562cb571912fa6" => :high_sierra
    sha256 "aa8aa6c63e5cd626ce78146912c8abf79d2ed110d3ed0501482a88f421dce4b5" => :sierra
    sha256 "2657c5809a086a8bba8d2ed81ca56f5640a5eab69723aa3ef342160c64c84cbd" => :el_capitan
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
