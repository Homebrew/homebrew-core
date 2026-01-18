class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "c8867631aec7789d8795c93d3ddf89e46603c1bb0881aa0ccd3b1b440e766f28"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2110e1e81233a4e698c01b4373fe9bf9c366b32bf9721940cda8128f592ded1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2110e1e81233a4e698c01b4373fe9bf9c366b32bf9721940cda8128f592ded1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2110e1e81233a4e698c01b4373fe9bf9c366b32bf9721940cda8128f592ded1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "53e38cbf92c3b35761120fc5337429431eeb02f4311ac1fa0751019a316c70a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f480cda24033dda813a7b46974540b196e976fbf91a9958c93750358b1b390ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f2eb56826ba89babb3a752e585b6592e34f62bf76df6eefe188e9b9eaf1c56"
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
