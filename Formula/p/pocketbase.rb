class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ganigeorgiev.com/api/git/pocketbase/pocketbase/archive?rev=refs/tags/v0.42.3"
  sha256 "35e6d0ba99995a37380ce966ff1c7aa95aa193940c8917151ed2c76280e87e29"
  license "MIT"

  livecheck do
    url "https://ganigeorgiev.com/api/git/pocketbase/pocketbase/refs"
    regex(%r{refs/tags/v?(\d+(?:\.\d+)+)"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31b049434bcf9242622132ee7a7c8fba7e323fd209ce1da49db2cec5f2915fcf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31b049434bcf9242622132ee7a7c8fba7e323fd209ce1da49db2cec5f2915fcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31b049434bcf9242622132ee7a7c8fba7e323fd209ce1da49db2cec5f2915fcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "531a449addf292777e39a82e18bc8244dc3a27e5085a30ba65d4a4dc94005e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7e5a382175f7a746a76e6da909510ae7883e594f81555599aa584b59c51b489a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-X ganigeorgiev.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
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
