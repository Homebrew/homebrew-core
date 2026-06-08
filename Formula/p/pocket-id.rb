class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "d20a5b4f538ab76ceae7d8eca079afa21063d486a61035e2fff378b46945878f"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d4a52a2f731344252d0416f4c28a178f61a7aa14799867354c1f3158557d8d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5611d5b11a31469115f1bd321e45c8a2c5f5abcd41583866a64acf34a37b4180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66c3b998c065313b21b4c373132cb662f194fcda33bc0995b3c868a0966289c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "aea71a1b1a2a796491bc3e078880740f1cd85e22986b8ca9a39449b9bcda5693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba97e30bf8b6041d18d6a8393f1518ae9d50357c2b9d1e3a352860fd7ff5340f"
    sha256 cellar: :any,                 x86_64_linux:  "07010adce01574ac2428dee26422aa311fe916faad3b36a291db1ee07fdccd0f"
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
