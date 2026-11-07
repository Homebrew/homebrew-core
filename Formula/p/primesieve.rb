class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.17.tar.gz"
  sha256 "c18fe8cef84d3cb4f1f5f37d3737999c00489fddc1b58327b61d1e31c9a5b49c"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5e0073096319b9fb4a8754e000c4d04c4539ec857601fe1442fea4a10801e9ea"
    sha256 cellar: :any, arm64_tahoe:       "ccaa74654491bce29f25e245ce362d5a3b310847542269f60733a9e510edf092"
    sha256 cellar: :any, arm64_sequoia:     "c795a6ee982185ed9fb0bdf2a93c70dae0529fb3174fbd9dfa9ccfac07dbb653"
    sha256 cellar: :any, arm64_linux:       "56dda390e93be389d7c13daac6afea28f1445d6bac774be8f17d923ca895abbc"
    sha256 cellar: :any, x86_64_linux:      "91814951c855ec14c9fd7371054803ea99c8dfd0bc37826592589233ac98c2da"
  end

  depends_on "cmake" => :build

  deny_network_access!
  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"primesieve", "100", "--count", "--print"
  end
end
