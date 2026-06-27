class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.4.tar.gz"
  sha256 "0a5b8731e694840830fb9e11999fe63268c25d8595c58047d5f55aa2f493f033"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09c945735c2d42dc128a76e7f466b1d7a7a5c5f568ff95dc436c32ebeeb1c231"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09c945735c2d42dc128a76e7f466b1d7a7a5c5f568ff95dc436c32ebeeb1c231"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09c945735c2d42dc128a76e7f466b1d7a7a5c5f568ff95dc436c32ebeeb1c231"
    sha256 cellar: :any_skip_relocation, sonoma:        "352684a9ecd3824105e63e8c8d62c49519a1f05f318e027f2276dc533d9a5155"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f687edb7ebe6921974329bcb90bcf27b77e9b3ca04e71a8e252bed54c243f455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6952cc0c8a2e3e7351c4a98cbf99e335e1735bbe67b674c5e37025507f59ae8a"
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
