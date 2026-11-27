class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "a70093278dc8742946c55a58825203ffea0f380969cc2ab50563bef378f75f13"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    manifest_sha256 "f185fab0b6574dc28377d0e8381052ad180c9e298ab79fae71b4cac7127c83a0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0a2d36fca0a5bfffc714beca54f24b9c7adbe93ee01a74ea8c0b35a4b00572f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b08f4bab6621213934bd8cb8e3167e859f0931d645e45b124d4a77a5bec359a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aaf5199e2e695cdf4cfe13f66e5494a280829c541deeb4e7bb14b31288a5e13d"
    sha256 cellar: :any,                 arm64_linux:       "26c3036e6f68d43a181083275727c3c45305e75c71e33f284197476aaedadd96"
    sha256 cellar: :any,                 x86_64_linux:      "355a12279dccb9b5ffcca541600a5313f1acf99062e8f08c6015d7290f1969d8"
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
    with_test_process(bin/"dumbpipe", "listen", err: write, out: write) do
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
      with_test_process(bin/"dumbpipe", "connect", node_id, in: sender_read) do
        sender_write.puts "foobar"
        assert_match "foobar", read.gets
      end
    end
  end
end
