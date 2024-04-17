class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.22.9.tar.gz"
  sha256 "5e9bbee3e0fc143a23176e32335b83771af24c86a5d1ceb6231fd501bf1d5694"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5e1e427add788d7183e18cb2c1cd74f927794ffb65ccced4f55548596992d02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5e1e427add788d7183e18cb2c1cd74f927794ffb65ccced4f55548596992d02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e1e427add788d7183e18cb2c1cd74f927794ffb65ccced4f55548596992d02"
    sha256 cellar: :any_skip_relocation, sonoma:         "c863282d0d0f39292d0270ffc93744b6068c6ec693d304a4fc6631c5481ed598"
    sha256 cellar: :any_skip_relocation, ventura:        "c863282d0d0f39292d0270ffc93744b6068c6ec693d304a4fc6631c5481ed598"
    sha256 cellar: :any_skip_relocation, monterey:       "c863282d0d0f39292d0270ffc93744b6068c6ec693d304a4fc6631c5481ed598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ed6e0f07f6111daf0c9f8664374b7cc6e00e877f9c4a05892fb7072e65e05b9"
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
