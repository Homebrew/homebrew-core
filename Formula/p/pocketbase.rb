class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.40.4.tar.gz"
  sha256 "969a4db498382d120dcd9c801481e7166cc6adec97e67c966a75c3b0c2a09a85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "945e8b469daf9f981c4f57102c0931dd109d982748ec74761f488c048cc8b0b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "945e8b469daf9f981c4f57102c0931dd109d982748ec74761f488c048cc8b0b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "945e8b469daf9f981c4f57102c0931dd109d982748ec74761f488c048cc8b0b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3d0f1543bc9ec9d1cadaa746960852359a53fe899ff7ad10beebca648bf1cb86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "58ff00226276e0f2c327c4730a8f675dbda60137bccbf799aaec63df95cf6c38"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}") do |_, _, pid|
      sleep 5

      assert_match "API is healthy", shell_output("curl -s http://localhost:#{port}/api/health")

      assert_path_exists testpath/"pb_data", "pb_data directory should exist"
      assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

      assert_path_exists testpath/"pb_data/data.db", "pb_data/data.db should exist"
      assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

      assert_path_exists testpath/"pb_data/auxiliary.db", "pb_data/auxiliary.db should exist"
      assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
    ensure
      Process.kill "TERM", pid
    end
  end
end
