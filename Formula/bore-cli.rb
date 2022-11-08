class BoreCli < Formula
  desc "Modern, simple TCP tunnel in Rust that exposes local ports to a remote server"
  homepage "http://bore.pub"
  url "https://github.com/ekzhang/bore/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "ab1f3e924ce8a32eafe842de0bb1d23eeeb397ec0ad16455b443206f0c9ee59d"
  license "MIT"
  head "https://github.com/ekzhang/bore.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4bbeab240fd9acaa0d02aac488bda8e33c9bc57d4757a493fdfffb6b046f673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5a395cfd1b08d9ec96f175b6680ba2809ac2882482735329a38e663206caf58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5d8bf6bb647ca2d515710206fa1502afcdb4f2d507bc448e991850ff83a51e8"
    sha256 cellar: :any_skip_relocation, monterey:       "e662ade629f5dc998e3ad0ea55a3645b67b89e8c172d93d197da325f561d7705"
    sha256 cellar: :any_skip_relocation, big_sur:        "31e99b44a4db6711a24f255184cea1fe9739f4194a25a6e81091cd749e5edc5d"
    sha256 cellar: :any_skip_relocation, catalina:       "a44420ec11a9dc92c3656e94e9a10069ef2017292f6e383cc4548562faa08a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82a653b1e4cdc05c232e1279b1f62e2a8a816868e778d4858ae9520cb2caa626"
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
