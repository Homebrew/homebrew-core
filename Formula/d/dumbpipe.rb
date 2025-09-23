class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "69dadd34b56ff18320a27a69c66cf0591b2f11ee725427b4a281928d269fa905"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b7cf4e95b2cd8c19fd6fd757242e1c595e984582a3d7a001a0210798a83d1fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8da355eab9b6d40fd0af7e17e6b2836d607d9e03435bf2a2f783c2e146903ab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dfbb7339265641e4ace1727824e981204118ce52f221b1e850c1097f8ade261"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "315cd7b67781cc009c5426993cb28d486bddd3e242d5ff56ce7370cec725e4fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a4b735f4a327a59e8cc37857ba5598eff8a6de5d6ddd3dd22edfc1c6fc557f6"
    sha256 cellar: :any_skip_relocation, ventura:       "f80ede8d2179727cae39b01c9d5f7794db59f82e1b2181edab39097945d0b420"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "005c5ce256398a076425520f77246b82f1b77bc6be39d19d5fd3cd00a018a00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "687daa777f73debed74ad2fa5a1d7b42acc9460e588136eaf0a835315d989fcb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    read, write = IO.pipe

    # We need to capture both stdout and stderr from the listener process
    # the node ID is output to stderror and the listener data is output to stdout.
    listener_pid = spawn bin/"dumbpipe", "listen", err: write, out: write

    begin
      sleep 10
      node_id = while read.wait_readable(1)
        line = read.gets
        break if line.nil?

        match = line.match(/dumbpipe connect (\w+)/)
        next if match.blank?

        break match[1]
      end.to_s
      refute_empty node_id, "No node ID found in listener output"

      sender_read, sender_write = IO.pipe
      sender_pid = spawn bin/"dumbpipe", "connect", node_id, in: sender_read
      sender_write.puts "foobar"
      assert_match "foobar", read.gets
    ensure
      Process.kill "TERM", sender_pid unless sender_pid.nil?
      Process.kill "TERM", listener_pid unless listener_pid.nil?
      Process.wait sender_pid unless sender_pid.nil?
      Process.wait listener_pid unless listener_pid.nil?
    end
  end
end
