class Lazycontainer < Formula
  desc "Terminal UI for Apple Containers"
  homepage "https://github.com/andreybleme/lazycontainer"
  url "https://github.com/andreybleme/lazycontainer/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "c674297ccb1c3897865e4dd14d64ce7346f04f66430c125ad6c8bdfff0ba4228"
  license "MIT"
  head "https://github.com/andreybleme/lazycontainer.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "8104055ed3ee692a36571f79db76e927b9ae43e7fec301c9c8d859ced6687d90"
  end

  depends_on "go" => :build

  # limited by Apple Containers support:
  depends_on arch: :arm64
  depends_on macos: :tahoe
  depends_on :macos

  # ref https://github.com/andreybleme/lazycontainer/pull/11
  patch do
    url "https://github.com/andreybleme/lazycontainer/commit/cc9ad42bce4a28d662726c41b55dc28d2cb6eaae.patch?full_index=1"
    sha256 "7b1703ab7e11a1b655845ad98647fb01feb815db5caa1c42498169ec83f99ddd"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    require "pty"

    PTY.spawn(bin/"lazycontainer") do |r, _w, pid|
      out = r.readpartial(1024)
      assert_match "Error listing containers", out
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
