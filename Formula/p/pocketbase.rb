class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.6.tar.gz"
  sha256 "116c4633c33a9ac7209c464258680ce472d4215ed5e724920a3bb08cb97a8444"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7107a35474ac173f91e5468b662d0d2b3f5580949ef8a093ffce31a41345e59b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7107a35474ac173f91e5468b662d0d2b3f5580949ef8a093ffce31a41345e59b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7107a35474ac173f91e5468b662d0d2b3f5580949ef8a093ffce31a41345e59b"
    sha256 cellar: :any_skip_relocation, sonoma:        "defa928107b68ac48179b9bc2486199adea58d66b291a9511f5b6ffb39d19b78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b354d763b490b9e23eed96e28ca824c25e5512999288c4a19077c3a98c8ccc4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c46c77c261dc47c2c33394ac6f0a41cb3440839d756bbc16c5bc72e0d7878f1a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
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
