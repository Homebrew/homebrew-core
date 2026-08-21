class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "89d01b0b6d25fc8baf06ab791fd0a2b35b24ac51d0bd01b64d36c35750aaf3e9"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e05d87e00a7c62a14300394036ff51feeebe678e70b3db48eb9c7b31de056d5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62dd490b4f66c219b9b06de5d56c50ffb897ffc6c9b7e0071083a3e0528c1c79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d709d1b06dccadc777579b38f24fa6463cb2f9714fb43b342e15033660e12a38"
    sha256 cellar: :any_skip_relocation, sonoma:        "45e6634404d8dd88999d88e0b82171ed1c23ec502fce3665cbbdcfa088fbbf81"
    sha256 cellar: :any,                 arm64_linux:   "e2db7a50c56e0ad039b49ce915d53ea8c2da345fa699007408cdb6b80b7f52a5"
    sha256 cellar: :any,                 x86_64_linux:  "ea3cc5d6f5f6c725e9326f33df5b24250586d2d1df22c4bd4734f66ec7ab6472"
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
