class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.37.3.tar.gz"
  sha256 "3206ecc895cc9702d5a1d0c2a9c9bf651cb9b0fa73934b3dc5f953d146e73132"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b44407bb4e4eda272d1bb22697da9d6af8fe49ee841a52939ea46d6637c3fa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b44407bb4e4eda272d1bb22697da9d6af8fe49ee841a52939ea46d6637c3fa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b44407bb4e4eda272d1bb22697da9d6af8fe49ee841a52939ea46d6637c3fa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "311030b70453a712c6455f31866b9008a046628893b5a33360b9fbe5559ae0b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c7bb3e562e33f498f34520d940df2441a623e19a11086d7a1d30f943f3afbed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50a6c934bf4f9623507046db5a84dbaa95223e9957eaee71d59bceb2d37ac74d"
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
