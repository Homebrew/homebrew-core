class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "880f5b0ba0d3c39cbc84595676782f50a25f87ad1b7a77d35cdc590c584b2da1"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4e04135d59ddc9e5ef8a8f118010cbe5e0d89bb4734b04ea0fbac68de480309"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb34323ca44a9bd437b1edb1141403bc3fac73d6a81e00352e6d09d53da5a18b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e84a9237fc1d3d705381850c792c8e1a3ffacc56063a538297a00d6265fbae6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fffb593d126b6842a041fcb8bcf2c20e7e07fe5a4802409f6a3d6c8a60ec05f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29ad44441bc079a7632f6e82cee77fdde7a7746a0cbd8ced63142eb5764a6dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d9aec0fbf0c66e4fc0f047410b212fbe098f4a7e0b6a7f6c6cf9d9e0a07660c"
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
