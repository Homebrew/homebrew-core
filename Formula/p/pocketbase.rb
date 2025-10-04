class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "13c32ac6667c9dab430bbba79d21b35ccbd7e16d511f856d4800af47792c5286"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b424b15a637fa1e187deb37c155dad129e81f54e31d5528caca726314c8e15d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b424b15a637fa1e187deb37c155dad129e81f54e31d5528caca726314c8e15d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b424b15a637fa1e187deb37c155dad129e81f54e31d5528caca726314c8e15d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7960a79ae15a990dd21e439b2a3a50ed65f51191613ffdfad8f2caf684c8c1ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d841ab16da5754c7e25fde47b39ba83e2760346a8f052bc24fe61a6d085650e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efb642c9f40771d2348101ef9ae1ddec9cbf71c82f16c76a7970cf65916f24da"
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
