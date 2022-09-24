class Gaze < Formula
  desc "Execute commands for you"
  homepage "https://github.com/wtetsu/gaze"
  url "https://github.com/wtetsu/gaze/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "e4131b29a2e089d2ba9bd12c0422f674214a8ba04795f97268b931a418d07104"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8eb8e9be30445e9cf2b89da843c1658e76dcb368537295655800b5eb3d44612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebecb5e90711f5156824bfa59a4bf123364349225b27716a9297c8c369ac7a9d"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9608ed9269d536ab7c6ac57b71976b154cf5e2f68936417cf76192ef352011"
    sha256 cellar: :any_skip_relocation, big_sur:        "b83cc8d8c7e765e4cc1844a044ebe6d46ccedcf0d52eb8ecc54bc496b9500565"
    sha256 cellar: :any_skip_relocation, catalina:       "27a5bfb76379fa3b22e340939ef1878871513ebffdca4d1595eb5a65b892336d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be6e273ee53f4dc47ed78c9d54f0b3671f6193cc2f24f4759cf21ca47f684f82"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/gaze/main.go"
  end

  test do
    pid = fork do
      exec bin/"gaze", "-c", "cp test.txt out.txt", "test.txt"
    end
    sleep 5
    File.write("test.txt", "hello, world!")
    sleep 2
    Process.kill("TERM", pid)
    assert_match("hello, world!", File.read("out.txt"))
  end
end
