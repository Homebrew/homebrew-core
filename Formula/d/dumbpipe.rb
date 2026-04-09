class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "e001c75a8c5dacd828ec15797b6ec9502b8314a37f7e4974499c743069d60d2f"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "449a3d7eb75f6ec9ffdc311cb7b3e34d769c12472868ab4b335f13efb6b4cddb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d399075e272dddfda0c86ccb516abdb3275c9aa34111934a05551d27c545cf71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f94891cbbd5d26edea6829cf1a7eb0092efe58a70289b823dc4e778f27299302"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a1c4c45e8356d173aa4495e35d06402154c3dfae84a3906c68cdfea53848b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "345b1068b400e789c4e4bbdba6e2a2999f653cc5243f6a7787bd3e8281051540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d86a248dd4de4f6e2b7a39f03d60383c5856ffecded3a7ff4bf86b5c2ac986"
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
