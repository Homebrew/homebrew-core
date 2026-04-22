class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "9a8b59c49f10ed4a33c6b89d2505df7a7afbd3f0fa3d2f5ee5e376821c63c8d8"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d246740f92b8953922ca1a8f121fd665bdaf4eaa1d56192d2d01e7b6a68fe97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aecaf2f1118f4a4970654af709f2524f5eeee0137c602d317ed95f2135ffb0e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "667c9d8adf9bf7bb09581c76a5341c66065e61f6a5e2078e43e014f7232529db"
    sha256 cellar: :any_skip_relocation, sonoma:        "539d0a7a5213461c727c8fe447be40cba191a4f9a028947965e8742f00735dc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b1e8e526a467f9b40e2e66f08b3c7644fa5fa27e5c35adf69caea5f010f241b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55d708a2a0a195a4e43f8c08338817c67d302fd8418fd765a13731eaa93d73b6"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    # Prevent pnpm from downloading another copy due to `packageManager` feature
    (buildpath/"pnpm-workspace.yaml").append_lines <<~YAML
      managePackageManagerVersions: false
    YAML

    system "pnpm", "--dir", "frontend", "install", "--frozen-lockfile"
    system "pnpm", "--dir", "frontend", "run", "build"

    cd "backend/cmd" do
      system "go", "build", *std_go_args(output: bin/"pocket-id", ldflags: "-s -w")
    end

    (var/"pocket-id").mkpath
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
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
