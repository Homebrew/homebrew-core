class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.22.22.tar.gz"
  sha256 "c877af435243b6c1ac26339ade67497d4862d33fb6e493188de1024fb9866138"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a78f6e60c20f8b8fdc30464275eec484595513651653812321be948d224c843"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a78f6e60c20f8b8fdc30464275eec484595513651653812321be948d224c843"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a78f6e60c20f8b8fdc30464275eec484595513651653812321be948d224c843"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6f948758400987da40435d64ee2b40aa5fbe84a1c5cedb79a97ccfee2e8924b"
    sha256 cellar: :any_skip_relocation, ventura:       "e6f948758400987da40435d64ee2b40aa5fbe84a1c5cedb79a97ccfee2e8924b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d587a9db21cf495f63c7e19fa3d3ac1f8d0342db0e5bba9bef4cad465743852"
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
    Process.kill "SIGINT", pid

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end
