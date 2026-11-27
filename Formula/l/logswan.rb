class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/refs/tags/2.1.18.tar.gz"
  sha256 "f57fb25901412d33d1386012f95f70087c81bfc4a0aa7733723799de7d60dee8"
  license "BSD-2-Clause"

  bottle do
    manifest_sha256 "72599c1dc5eed2ede981cfa59383c6c5ec2188a05bede9161d318efcf889fdd9"
    sha256 cellar: :any, arm64_golden_gate: "2884466f15b57a27cc3c5dc98c5c2bc77317ebbe9b58a58a69cf2ac1bbe034f3"
    sha256 cellar: :any, arm64_tahoe:       "cfb00ad36ff3e22ebebc4e45631fd3836621714b05961a5690ecc65bcadd74f5"
    sha256 cellar: :any, arm64_sequoia:     "99d050e73653a1aa10d89841ca55cb46ffb38aa04b3ba989044cf01bf7f18f49"
    sha256 cellar: :any, arm64_linux:       "09f0744f4cf2af0f22a441f41c827dade20717f60ee8f0b068fcb15c19c89112"
    sha256 cellar: :any, x86_64_linux:      "f8101513ba48cd6d12720a2d478b2f04e87d88820d7de1874cfd364d2addb266"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "libmaxminddb"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    assert_match "visits", shell_output("#{bin}/logswan #{pkgshare}/examples/logswan.log")
  end
end
