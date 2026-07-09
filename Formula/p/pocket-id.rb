class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "5938a9aed5d41c75ff0d58bdf43c4f63eaf2f479783a09ee301dd38e7c9d3bcf"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa462fbeedb01a10c5aee89fb321b3d0e149f6081924bbf95a5c6f5567309431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fa645a38443ead1fce06a6db91f3164a9d0bd8efcc94cacf87b1d03311dd949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1805849d2263c0eb9cecaf8c795f994b82bad47ff976390584e652f2ca22d4f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "21119bb67b3f77c47a589f171dd08184030e29b813bc2c093f1f5eb1bfb7abb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3b39ab62279013d2ea1edaae68006b72c6ffabd7015a184fce9965e68afa19e"
    sha256 cellar: :any,                 x86_64_linux:  "6bd1d45ef40c0578419543d0f7be07c8dfe4d5799cd0f64813734d21d8a582d6"
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
