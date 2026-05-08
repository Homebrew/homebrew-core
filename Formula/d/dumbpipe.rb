class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "7574d4805cc644ca61b5a833decaf98c35b510cab952004c2997a9d0dfd9a371"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0281dadcbc93c52e9ffd424be01a308ef2b675a7bc585aafdf7760f0b328c08b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6495a8d44cb03b34f6a1505e56cce332badca8345e1faa108c0b508d39ae14b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54cb7aa0115a721ff5b3db1fad4e5d1d8e19f7031fe7312ffd714dc51e413be1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d4be7804148d7d6b07b363fd0a0df8c6efe3d56ace9d031e30ed360196958dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62c9949b7a6c1f623eafd404ce78db8e650ea67ed3fb7c6e177009c4fa639da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "734071f706b56540033c9e4cfbf9be295891224e76637fc0bcd2ec6071cab79e"
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
