class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.19.2.tar.gz"
  sha256 "2a6cf4776e23fc660cce7fcf3ed1c16c50ea542046c533f5be5c1fd310e74752"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f02f3af7b96006c885d08e53bbf31724f48684788d3cac82a9ebb4b3ce598298"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2b428147a6f07dff93a8ac04638f723b94fe7ef94274a83d187739a68f24919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "339e69c3d5197ea2abec515b0c4a1a4c45e91e7a2ad7f7261379c72b7701c615"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dbdfba61706208369fd9be0adbccdd583ccc510ccfd7bee9ff82379bb7b4bc2b"
    sha256 cellar: :any,                 x86_64_linux:      "9736d367a6c2fc239a7c5c04340818552e8930d9217782f84bb35111ea21eb8c"
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
