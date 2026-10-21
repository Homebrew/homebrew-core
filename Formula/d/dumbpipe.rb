class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "04717f503fadd0ee86747036b232f89432c9d5ac2083b626019095f3f08266ef"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d7cda2d238687b5a766412b43bbaed1fe2f8370f19b561bd82b301795f7bc4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2eb08b7c50e5a1ff1b4cfa3cdfabacc4132cf311c86fe76e0889087908234a20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6ada0e9d8e36ac5c2f2c3df258c3fcaae3ddb7830af2209e3b998d4f62c8e43"
    sha256 cellar: :any,                 arm64_linux:       "760cbddecc9578eb0d56b590754c49390201b98d40a7e8ea614906521a0e8571"
    sha256 cellar: :any,                 x86_64_linux:      "51d4f93a85d978a28b5da8bc48eef3e6299a92debfda17b877ab8411223b2b8a"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
