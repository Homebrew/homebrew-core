class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/refs/tags/2.1.16.tar.gz"
  sha256 "9b1e944647114cb9cb6c42370369d4aa0d3de011eb518e12af3c25b0fb19336d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9332d6b9093ea70660ed6fda5834c76c60a5bd68d069ba5d766902d77d2b95d"
    sha256 cellar: :any,                 arm64_sequoia: "68e48b65ca63fd9ba94d96ebc8e72e9b324d0de6286d001eb6294b8e99989ba5"
    sha256 cellar: :any,                 arm64_sonoma:  "89baa68dc3c35d2e0220e1ebd97d0a83c4023af411a80e257d58c0c96441bf69"
    sha256 cellar: :any,                 sonoma:        "924f3b9130a56a68193e8d209cfb31dacf2a7347dedf355c5c43454cb386466a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff8dd3ec7671cea407b56821c73c11a0c4b53331476446f74f350c356d876e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "694736b14898f12898edaebc9ba5f07d050f83fc59f16c802c89b66a67c816ee"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "libmaxminddb"

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
