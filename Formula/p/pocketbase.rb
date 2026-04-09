class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.36.9.tar.gz"
  sha256 "e8e82d961204b3055e183df3a11f34127d8494899a78ffd854567a4454951d38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "415e7ab36977df0115903ec4b423641350270cb812614e1ceb7c80c9be30c4c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "415e7ab36977df0115903ec4b423641350270cb812614e1ceb7c80c9be30c4c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "415e7ab36977df0115903ec4b423641350270cb812614e1ceb7c80c9be30c4c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "78de6a724205376e9ad528043eac9b05d6f5c80befc196d41f22800bbc6881ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73dc273ea8bdd9f4e808487678ad654422f4b33fc597801d6b0e7bd364976f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce9dfa7bbd2fbdc8ff058b57e378b641ba94e614f0eb7eb5c8ffa1cc5adeed9a"
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
