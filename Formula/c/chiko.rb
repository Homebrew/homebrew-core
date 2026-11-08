class Chiko < Formula
  desc "Ultimate Beauty gRPC Client for your Terminal"
  homepage "https://github.com/felangga/chiko"
  url "https://github.com/felangga/chiko/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8c12a560226944a1074e3cdf273d705c122a91e60d4f3316e472e804ab56b697"
  license "MIT"
  head "https://github.com/felangga/chiko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cafb1c8782a9f8da2f73721d6a7bbf5d9071a536adaf5ee44613b25fb68fa7d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cafb1c8782a9f8da2f73721d6a7bbf5d9071a536adaf5ee44613b25fb68fa7d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cafb1c8782a9f8da2f73721d6a7bbf5d9071a536adaf5ee44613b25fb68fa7d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3f2a25d8a057758107db70aa52c18b7fb730d5aa217d9d88372dfcc231b2d98"
    sha256 cellar: :any,                 x86_64_linux:      "e50e51a6dd1055b81fcfc776d99b39feb8913a2607cc3f62361fc91db84b10b3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/chiko"
  end

  test do
    ENV["TERM"] = "xterm"
    require "pty"

    PTY.spawn(bin/"chiko") do |r, w, _pid|
      w.write "q"
      assert_match "Chiko dev", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
