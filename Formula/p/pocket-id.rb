class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "d0631899a9e04dc0165ea3fd97492e9a09784134b70e38c3960dda282126245d"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd7b40b69386f15d85141162f81dab473066f85f0081d7bdf98ee8be5f32c5a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d073f48f67268f078e04f0aaf140048e28b9b5b812ffad35ef67a1d805f96000"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b7a77e39c489817f553e04edb0828b82e9d30c7bff945ffb03cb87ab5654171"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d5960ebe48cb4980bc32c84fe2c251b126bf6d0ed8c030ee79f6cf328ebf1531"
    sha256 cellar: :any,                 x86_64_linux:      "f2aa4083b9c910e97570df8658d331ed5066ce5b90db768ad2a0f7046fb57af7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "frontend", "install", "--frozen-lockfile", "--ignore-scripts"
    system "go", "mod", "download", "-C", "backend/cmd"
  end

  def install
    system "pnpm", "with", "current", "--dir", "frontend", "run", "build"
    system "go", "build", "-C", "backend/cmd", *std_go_args(output: bin/"pocket-id")
  end

  service do
    run [opt_bin/"pocket-id"]
    keep_alive true
    working_dir var/"pocket-id"
    log_path var/"log/pocket-id.log"
    error_log_path var/"log/pocket-id.log"
  end

  test do
    port = free_port
    (testpath/"test.db").write ""
    (testpath/".env").write <<~ENV
      APP_URL=http://localhost:#{port}
      ENCRYPTION_KEY=test-key-for-ci-123456789012345678901234
      DB_CONNECTION_STRING=#{testpath}/test.db
      PORT=#{port}
    ENV

    pid = spawn bin/"pocket-id"
    sleep 5

    system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/health"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
