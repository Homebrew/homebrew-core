class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.19.3.tar.gz"
  sha256 "ee2525db7061b355deb5f12eb6c15465faf7e7b5fffd7b9915919d40cd8af54c"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5db29c8746544f321bdc6585df7990d3b60e0849081520e8bc2e28b4c1a7e46d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "583c06c29a31e14b392d23ac187981714d70f65871d3769de8b23ce502125f65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eafec707e4c3c59dca51c914bebd1689dd39491a003b6ea7b77862f09e7c5253"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "31797edb1c574bee13b7c2df24ad7f841b40381f731ef6c15decd2aecc33f539"
    sha256 cellar: :any,                 x86_64_linux:      "2657b1afe6f5ef987ebb10201902d69747e897a49f8003f6be043c195959a211"
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

    with_test_process(bin/"pocket-id") do
      sleep 5

      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/health"
    end
  end
end
