class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "a5a3c6c1fa81151073f3c3876fd591e13879a2479c665dc747d1765946bef657"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe6464e6ebb46907ac9f31b5e3547e1ac00687023a505970a84d1547c0d9c9ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e40ae3f8338624fb15def9104fe2f92a19488b4bb138f0e22e1ba358b65c6bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d373f819c6b9ec41f23f16fcc113f468b629508ffc7e1e0734d9173769e72746"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8fd7b21961888ef6c4378ba184afa3726b44a74259aca1e73286b0297d0a1376"
    sha256 cellar: :any,                 x86_64_linux:      "9b063fc76ef16bf31772f3e1a7b0bb35c840dd2b6fd9ae4fc30d1b7107cad1e5"
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
