class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d7ac94e7053c5d3fa95d6c5582ffff9c5df091a198c88cb9d89d974d247f843b"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "881e28ef9ab2ddea122a3c0560f0dbe02a4f117e805e96eb6dd96ab4d7e8b873"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fa301d5516472a02108a7430f07fb22c36148b65b671b87695fbffd8a9184d2"
    sha256 cellar: :any_skip_relocation, monterey:       "e4be9f220284d9c168821fbd14393cdaed68fa6ca81eb1eb356ebc2f62ce0b80"
    sha256 cellar: :any_skip_relocation, big_sur:        "b73ce3e76a181868dfaf2b84ddb41a869926d8a7151ed4eedd451d51249a1193"
    sha256 cellar: :any_skip_relocation, catalina:       "39671f9f21d8fd9063c54a8362d505372e5c8aaad7d8a05cccdaa45d2a90f5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04ea3965855d3af00e6a65bed5ad20caed5ba4b592d80573278224cdf36aa5ad"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # required by the xcb crate

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"

    begin
      r, w, pid = PTY.spawn("#{bin}/mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "q"
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
