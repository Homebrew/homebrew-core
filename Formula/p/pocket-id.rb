class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.19.2.tar.gz"
  sha256 "2a6cf4776e23fc660cce7fcf3ed1c16c50ea542046c533f5be5c1fd310e74752"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19b55ce3fb157873bc1aa62969fc3301e95017e5cd71749c12203deb29488fa4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04f117a97ad47ffd2bacb0221bd003fc312c84cd7aa966c76e47d328f87101ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "02a1100352b44b6d65d0a44d7035ab0f940a16b4815b013f0b1bb4d66210cc2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8693353c9c93ba1a8d4d41e91b9afc7f5fc5753d618ad7f8a254128d3d91ac1e"
    sha256 cellar: :any,                 x86_64_linux:      "7b6ffc734c1faf39f4601b6e9baeb3d64f8044afae820999b9773ced75bbbab6"
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
