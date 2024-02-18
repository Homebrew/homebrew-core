class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "c9b1cd211a53097fe14ab2f08954391e0f59fc1ba430953868cf8e7cf6578de7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d7b494be838357978891ee4e3455031d302b6b4de48f15f153f6c8a6b8fa7de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d7b494be838357978891ee4e3455031d302b6b4de48f15f153f6c8a6b8fa7de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d7b494be838357978891ee4e3455031d302b6b4de48f15f153f6c8a6b8fa7de"
    sha256 cellar: :any_skip_relocation, sonoma:         "e00e0411d923b74c10053ca61692a51dbf06b655fdc710bc417c54d8b428c105"
    sha256 cellar: :any_skip_relocation, ventura:        "e00e0411d923b74c10053ca61692a51dbf06b655fdc710bc417c54d8b428c105"
    sha256 cellar: :any_skip_relocation, monterey:       "e00e0411d923b74c10053ca61692a51dbf06b655fdc710bc417c54d8b428c105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd3a73d94466eb3d0e8cc9d122cf10639415da5c376c8956770a55a8cf18618"
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
