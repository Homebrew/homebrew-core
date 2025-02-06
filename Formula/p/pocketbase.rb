class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "5d4a2c959a752aa5f3d575b5e159272db1d2eab339750adada110188b6bb55d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d90f8e8c1ca5dd3874128a6f79883e78b469695f67e03cb073e2f8f1e357759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d90f8e8c1ca5dd3874128a6f79883e78b469695f67e03cb073e2f8f1e357759"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d90f8e8c1ca5dd3874128a6f79883e78b469695f67e03cb073e2f8f1e357759"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd1ea7d145953a9072a1a66d60a6aea7126877116a212bf5ba90341a139686d9"
    sha256 cellar: :any_skip_relocation, ventura:       "dd1ea7d145953a9072a1a66d60a6aea7126877116a212bf5ba90341a139686d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f59c661dbf3a519176328e38e2fa42cfcb79847be76ff97bd741917d20563cb"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/auxiliary.db", :exist?, "pb_data/auxiliary.db should exist"
    assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end
