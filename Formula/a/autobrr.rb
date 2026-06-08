class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.80.0.tar.gz"
  sha256 "578bae78c48ba270d5026ed51c0adefcbd30bfc830726cc35a2c5b9398250a54"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8582031e425b67ece6180472149d3ac1377a718c9bff69bb7973703648455254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49b54478292b6460e5c741d8ab01d0a549da9f64ec0eeeb42e1b09f9e6588a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35ea8c519f39cdd7b69527c500039b9e0a2429979b233f1cdc3979f9e198e2d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "17d5bb2e159b71ece04bf00c8082bf2437ee87446e6d2cbfa76ba52453a23941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43a6c291477d8ca4d98c07cbecf26e020ec9380082010e1c73f9e89366658e6f"
    sha256 cellar: :any,                 x86_64_linux:  "e4dcbf00318c9b6fc379b66a7b45466e2f596be526614ebb51777e6067ce1d43"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"

    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = spawn bin/"autobrr", "--config", testpath/""
    begin
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
