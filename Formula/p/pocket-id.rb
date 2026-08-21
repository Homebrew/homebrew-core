class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "bf04835908e5ad80ac8d5c3b7fd136f43d5e1bbe1953cb6d531a3226e2beec5d"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f04580a868a6b6e1864e441752a4826e98f339196e1e763cfcacfc53709935aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ec4ac3f5a8ada65a315b6591f79068cfa3f43b38b087e3c4fa9dc7ac9c3014"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2367ec8a7763724edb613b9249fb86074be774036287d71d3caafc6b685a6853"
    sha256 cellar: :any_skip_relocation, sonoma:        "34dd587d7dd3b3c1cda1a55b3e175324982a29cfd65ca40472d82378da91a164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de7b921d1ffb712c6a8b071f9487b9c30c94b8dd60e7e89bf1bef3078cf62a79"
    sha256 cellar: :any,                 x86_64_linux:  "224088ae6824d117440d1d8d6d2aa33886fc012d668303bb18793c9436d6a234"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "frontend", "install", "--frozen-lockfile", "--ignore-scripts"
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
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
