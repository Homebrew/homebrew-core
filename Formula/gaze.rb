class Gaze < Formula
  desc "Execute commands for you"
  homepage "https://github.com/wtetsu/gaze"
  url "https://github.com/wtetsu/gaze/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "53c46a09f477433e9105b9df8db9ddf287fae6734b3078d79f5f994500e8625d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9661658a4002ec61e5c8e66bbd12e87d56fd2169b2acbae2ff1730fb28763c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21415b048a0d0703840e3383e4581abaead69378b946f95e82d1dbfe30c1072c"
    sha256 cellar: :any_skip_relocation, monterey:       "c69c1dd7a2a2d77425fc040cf04d542d573bfc0d3217209f4524407aa43012f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b749b2b37c58450dc62e0490423f7690bcd656d09ca3bd53448f4f673d461ceb"
    sha256 cellar: :any_skip_relocation, catalina:       "1f5cb6ff364f5bfc352f6da7d894e1048db1cea534f1a2f27ae1326e37d7be24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "869b4f50685c5ddec3a94fba1929ac8d96811f93c10754804528a5c6619fc2b0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "cmd/gaze/main.go"
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
