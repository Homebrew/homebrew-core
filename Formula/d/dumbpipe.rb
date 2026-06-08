class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "c9fa07d69d2fd4a640a6a8e2f0ab40f655f32ee37f6938c996a53f3c9af997ab"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb360358ceca41d4fba62e274c3b377797b455629eb4dda0d78a907d7de263fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79f458d004ddd3bd371a3955efe3db14dd9cc24d99169389cfcab3c16ac82f7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d45e45b80651f7fa9c5bc45d61f1e69da8e0ce780cad70e888f6e9e26a7841e"
    sha256 cellar: :any_skip_relocation, sonoma:        "af743869ed0b004bf6c7fad2d6b25703a1cc8cf24b09175821e0171ff7e7e400"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eed1b324d76dec9062456aa05b4fa1ea3a639221692e7a839cb2011cab1fa37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cecb90b25af094bfbf2a737b622927a47b7f53e0f012970e0246b344b1f8a9d"
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
