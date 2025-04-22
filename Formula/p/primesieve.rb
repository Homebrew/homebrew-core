class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.8.tar.gz"
  sha256 "a0bf618a60a6b815c628196da9cb47e878e1414a06b4025acc5a1f9050223282"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "072dc55469ad98fde0be15c7a76f5c445ad8bc7b0a6197dc6384c9f3b675b7cb"
    sha256 cellar: :any,                 arm64_sonoma:  "28fdf884dc6f4c4d9977a49d3179d5aa5f440f3433e86e2c7c0052dda2184216"
    sha256 cellar: :any,                 arm64_ventura: "a053a061ebff146a659ab8d7b78ef5d6a20fd7ca791dc20d1c4e2f655edd5b52"
    sha256 cellar: :any,                 sonoma:        "17f77017c06b4a90342698668fbdb77d97acf7af1b9456a2553be1fb4c9d1629"
    sha256 cellar: :any,                 ventura:       "dabb01f28475cc7d04cd19989ace39586869bba156a8acd35effc1f4dfe0758e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22b00e5b4b4990a40c2c17dbec815193809c38dd4c4e37a70acc66bff091268b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5122a6511be3675c9bf086442ae5f939a817cda7d83fa34b675f6c6d2ffee4a1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"primesieve", "100", "--count", "--print"
  end
end
