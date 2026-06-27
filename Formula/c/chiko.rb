class Chiko < Formula
  desc "Ultimate Beauty gRPC Client for your Terminal"
  homepage "https://github.com/felangga/chiko"
  url "https://github.com/felangga/chiko/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "227cfcb5e581b7201519f260c0ac279eaa3057b39f9f12b60103f4794daa8071"
  license "MIT"
  head "https://github.com/felangga/chiko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e05bc75aa70da03f9440495b32c0959e76115bafa14bd4ad61725d5f9b5eaaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e05bc75aa70da03f9440495b32c0959e76115bafa14bd4ad61725d5f9b5eaaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e05bc75aa70da03f9440495b32c0959e76115bafa14bd4ad61725d5f9b5eaaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "654357e462c4f2152aa3672da22b83b71ba7df778f6cfcec157851482b48909b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2909a2e1fb8edd2780b365eb47dde35da6025a1e2af3b21119f0f82d0c618a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "257de2678cbff663eb7e4c74e4c8e0db3c3726a4a3906d22cd0b8ab2c2560695"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/chiko"
  end

  test do
    ENV["TERM"] = "xterm"
    require "pty"

    PTY.spawn(bin/"chiko") do |r, w, _pid|
      w.write "q"
      assert_match "The Ultimate Beauty GRPC Client", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
