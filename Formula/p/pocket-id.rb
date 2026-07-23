class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "6fb65a65dd6ec19876e37a6e2b0134d54c7ac645e3137efbf429ab777566656a"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee6161762c697aaa382ff7d4753e0d73add6d6e0de51f20a701b6646f3fa2ad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01be66d5ee399433d90553831eaa3a2f3c306ce799b33ca29e49d5b2f3177e92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c107cec9d3a589b6939b6e2f0387761044f0f999f7c9a2ad7e7004919fc8168"
    sha256 cellar: :any_skip_relocation, sonoma:        "13a6ad566c5b2e921b1c53bb310ae96b1d6ae1000980e122b6983c506a30cf96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f39ad68188f6f6eefb5e7b0173804fad1d9f3f0b4d8ced88dc1835f4a5475cb"
    sha256 cellar: :any,                 x86_64_linux:  "5629bf899cb9af89309833d11dff87474b176845ef42cac93e163b9caa041b2d"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "frontend", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "frontend", "run", "build"
    system "go", "build", "-C", "backend/cmd", *std_go_args(output: bin/"pocket-id", ldflags: "-s -w")
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
