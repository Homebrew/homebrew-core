class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "843ed4c393feeeec548b5f3deba82f794bb9fc64c20b25bd69cfa3526c8e906a"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1605f4e4e91566db57398ff36878391ef79c65b72956f0200cd1714b7fe6c954"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0950a9c8cca0d8808d6b364af773ddecfe9b717def30dd8dc440aa2eb81f7303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2404008ac7d1f7dcb1540520136d7795d4b8ef8a6025737a11bbb8f64418df34"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4cd64f8b6b0cef363597dfef216b818e3a39f0f9ed935813cfb6c4472f5c5c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab895dec6092abaa53948d0a1e418ae01e1d9e1fa3a0e8754bbbd424e7199a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91760b5423b47bfc2c06517854faace046856f77d90d3f2f3620dd2d095281b5"
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
