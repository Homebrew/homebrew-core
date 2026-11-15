class Lazycontainer < Formula
  desc "Terminal UI for Apple Containers"
  homepage "https://github.com/andreybleme/lazycontainer"
  url "https://github.com/andreybleme/lazycontainer/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "171388ec6706b67a30bc129addf56910b6fc3a1811f7fae4200a9314e5e834e0"
  license "MIT"
  head "https://github.com/andreybleme/lazycontainer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da661af9f663b723ceb3433f5da6f21a47e6d3bc278ee279c33f683f9ce81ecf"
  end

  depends_on "go" => :build

  # limited by Apple Containers support:
  depends_on arch: :arm64
  depends_on macos: :tahoe

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd"
  end

  test do
    require "pty"

    PTY.spawn(bin/"lazycontainer") do |r, w, pid|
      out = r.readpartial(1024)
      assert_match "Error listing containers", out
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      [r, w].each(&:close)
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
