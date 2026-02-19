class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "3423d6c7df6ff7c9579511a4d0523da3913cd242a4fa888cffced5932c020061"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29ef54d4a9703603180e98e0090d1586a04e75e3b6099353d9da547072843ac5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64a0463bdcff85bf942ca5c2cb7749bdf6ec883251302be5711e040feef834cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "811b5a4e652b0de6e52384fbd05c972c64ba3cc7a3aca5f668024cde8d82b096"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6ebc423c9924372dc5d2e3f872e78870580782071246e2eb7a689e4a7dc15ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59e9cfb5ed8d37f7c29777de417e0669ea45832612a3aadb454608de9ed477ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0549e78b9a59a4311c16fdca9159d6aff5aa3046cdb541fa1178d49af8a77958"
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
