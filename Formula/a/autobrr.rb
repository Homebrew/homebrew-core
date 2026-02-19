class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.73.0.tar.gz"
  sha256 "9200c5c228d55ef97b85b4b65cdb24a4bb912883e925bd35452a7f3d8b6e77d1"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3056b42293ff38de78b7e4f233580375cb03bd8b0771f38ea0ce8b7c5f9835ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa6f3c95b95ab1be4531033391f44f658664c00fc923becdaa6dfaf71f0ff46f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "873e53837e6f4cf256cc23f319f8e62f5765c4ffac66e393341e0052c2c18a56"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9b92694b88502b18b2a64b44f8af9c99cf2854192af3f409fd016a53fc5cc6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "275c66c3f5fa1bbdf77cfe7976a22d0d9091b155bf14e9467d8ace40067d5175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "485719ad2c83b6909f288c86d9f79ef4e5fbb224fa7fd9cd47fdcb4ca7069a39"
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
