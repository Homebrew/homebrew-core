class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "17bc0190772ff20a01e90d9cda6bf9a7695cfd50c0e1c3c6e146bdc8844ab62e"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aec4aeb307f764dcaa8d0aaf1c6f80003ba0e8961103086a5e0e185b7ae94af4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a37360f857089d9fb81a0a9429bdd298885eadf6be48c7f880a8903025763a9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d035cb1029f1a82d8ad655644fe1238deb46e72fd98021f513f10e38288b61e0"
    sha256 cellar: :any,                 arm64_linux:       "6c541436aa32b59131ec5636b689f4c7080fc8940288c574fe633cce55edd201"
    sha256 cellar: :any,                 x86_64_linux:      "f70943d57f1687c95927bd2de9dd2bed06a061d7635922d3614e2f1113cea62a"
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
