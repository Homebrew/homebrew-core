class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.22.11.tar.gz"
  sha256 "20a48bcb7354dbe486288d3bd2eb5d86d90b00501de006e3707df4c9d1833a7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ed3da9092ec73afa7480ffb25c4c9144777ab2334b8853b0899923cff713313"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ed3da9092ec73afa7480ffb25c4c9144777ab2334b8853b0899923cff713313"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed3da9092ec73afa7480ffb25c4c9144777ab2334b8853b0899923cff713313"
    sha256 cellar: :any_skip_relocation, sonoma:         "5558e4ad19933842ea6410a162f874462dd8ec3346f47fe191d583940590f126"
    sha256 cellar: :any_skip_relocation, ventura:        "5558e4ad19933842ea6410a162f874462dd8ec3346f47fe191d583940590f126"
    sha256 cellar: :any_skip_relocation, monterey:       "5558e4ad19933842ea6410a162f874462dd8ec3346f47fe191d583940590f126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e46f6e76e285ad2cd4c2228258d192ee5fae7f6d7d6f6b06fef718c4b32e223"
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
