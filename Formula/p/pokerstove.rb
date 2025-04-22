class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/refs/tags/v1.1.tar.gz"
  sha256 "ee263f579846b95df51cf3a4b6beeb2ea5ea0450ce7f1c8d87ed6dd77b377220"
  license "BSD-3-Clause"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1e01296c7643407ad16a6b088f9d332fd2af4afa1ef32f73b373899aae59ea19"
    sha256 cellar: :any,                 arm64_sonoma:  "9ee487daa2e45f4b5be25714ddda3f282ebde3926652c9d50b90dc52399c0291"
    sha256 cellar: :any,                 arm64_ventura: "5a06bb9fbeb33f3506aec1c7271e650b127938b71638a94a3552c2f0050ee620"
    sha256 cellar: :any,                 sonoma:        "3141d03acae5a77b360906f91d59b017852f17e4d05e99444fbecedd5f9a0f67"
    sha256 cellar: :any,                 ventura:       "0895e6cacc2202f228f0b5da270fe46df7d1aa622c5233ac36778c9575b39e12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4943f804a65e9d0a872a0f0ae086f509090fa295b989a6f5cefba4f4578fc533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6a4cce5e269cb4f965d3cd32db88e2e44ce5b0ba94d7b7f1badd7156e969312"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"

  # Backport commit to build with CMake 4
  patch do
    url "https://github.com/andrewprock/pokerstove/commit/8ca71960b3ee68bf7cbc419d5aee2065276054bb.patch?full_index=1"
    sha256 "379461a6e3258ebf9803ff4a52020d027a745e1676d7aee865f5dd035c51c6e9"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    prefix.install "build/bin"
  end

  test do
    system bin/"peval_tests"
  end
end
