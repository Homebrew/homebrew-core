class BoreCli < Formula
  desc "Modern, simple TCP tunnel in Rust that exposes local ports to a remote server"
  homepage "https://github.com/ekzhang/bore"
  url "https://github.com/ekzhang/bore/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d084024cfa14b3b1df065fdf760fced511c228ff2441eda7874e3608f7563783"
  license "MIT"
  head "https://github.com/ekzhang/bore.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb47ecce95ccc9be42a41eda84b836c24d51e3f0f03d7bc2f9f58930d44f1926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0df2603bf726d38c1bb460314d7aab187fde1c27da34317cbff46747ec84089e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3141c449ac083c080e231209c7bafb116e976dfec7e928be33fc8c2fb2e4218"
    sha256 cellar: :any_skip_relocation, ventura:        "d3f94ffbd3c2d3f8aa5759ca3067bf0720de74e30245f919713e3d11a9359076"
    sha256 cellar: :any_skip_relocation, monterey:       "a5b791059a772c80e99672c0b74cec175ca92e6d491dde57b4706e9725bf7d58"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0d502b5d29f2ac526f860d30df22672a3e4da6ad95a528e9fa57227914ff3b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e09d9b492e58b1953a5c04e5bc6e4b62d396fba96c92ecb6612b0c26fe5df1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/bore server")
    assert_match "server listening", stdout.gets("\n")

    assert_match version.to_s, shell_output("#{bin}/bore --version")
  ensure
    Process.kill("TERM", wait_thr.pid)
    Process.wait(wait_thr.pid)
  end
end
