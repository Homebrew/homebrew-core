class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.22.4.tar.gz"
  sha256 "9200b00828b5ea8345c147045577d5662b7e69ba743bba74d0c8ffc882ee3abc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df8203952e7642e1f163863121ec2c79d6c80d9189dfb170017417ff68cf8f0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df8203952e7642e1f163863121ec2c79d6c80d9189dfb170017417ff68cf8f0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df8203952e7642e1f163863121ec2c79d6c80d9189dfb170017417ff68cf8f0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "11a7a002a187b2445544c13c82675cc27e44efb40aa29619ef8126e7ed6cb258"
    sha256 cellar: :any_skip_relocation, ventura:        "11a7a002a187b2445544c13c82675cc27e44efb40aa29619ef8126e7ed6cb258"
    sha256 cellar: :any_skip_relocation, monterey:       "11a7a002a187b2445544c13c82675cc27e44efb40aa29619ef8126e7ed6cb258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fd3edbce424782a3b42764884bb5cb3586e8749d810c541bf0a0439a23faabd"
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
