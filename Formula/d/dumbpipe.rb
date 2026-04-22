class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "88088e77da5dc4c805f27d5b36cd8b3ea38626eddaf8dda7a0a3d5f4cb55da86"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bc114d3afa2e9dada5cab84c5118d3c08824d5a8690dbb1334c0781e12f4a5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bfabe3043deadc7b65609096ab779a8b83499fc3bdc02936a96e20d2957f6f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44c43cbe2d59c3c8e691c136a2cd4c74e75aadfc57d5c0d5adc67db08784f9fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ab236c97ce1851fb916380677fe9965aba57d337c81de1a5ac4d71bd6c2ff22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f682183fb6011babbd6952d7127056a22de428256a6f1275f53575ef2d1ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14728b2fabedb44b0d3d59e9b0ed94ee66d513e0d186daf1c137e20b8b06a3ed"
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
