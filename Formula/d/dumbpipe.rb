class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "0bad2bca9c3a8371ad864fcbba38e6dde47fff659b2108727d0643232aed7d04"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "186ff902c4a7c5980045d40e1b01bbacf42f0a24b9bd02de4185c046fe36933e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9164fc23d8544c05829199db18d91cdcc0cc285e2dfc3a46bc31e605d68e0289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2803d9fbf5c79bc29655e7a24ae7b2a3584720839b94a4e83664381e681d35d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bffaf95fd7210da7a4060784a85d220875f4c85c28667e0fa45d60c01c179025"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b8f470ecc8c619dbcff2e29fd0473578ab25fd873f36e6749b1a260484bc023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0bb0c771dd1d443fca078f6e93bbfd1ff8d5cab9e61f64513ee0e88b2bd6ad3"
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
