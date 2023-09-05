class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "d31206ca1eff121d4560e84a652a55efd0a8a01bf7fbcd30d524f0e4676cd75c"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23acdbd8105fb3dceae557eca1edade800d7978b5c00df8a72259ae3e3d87fd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0db4a423b26bd41d68bd8159615546909d2a78f245a2d2f2083d985617ad4756"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c09d0f120f6054ae9631b3b394891b99e7b41f7a185eb15c37568844a18c56be"
    sha256 cellar: :any_skip_relocation, ventura:        "45d549534bde1ac431a7d45e2b184225e61ca485cbd32566327de001f933e6af"
    sha256 cellar: :any_skip_relocation, monterey:       "fd59f377d5cbd6b51846e0897a57b0b120efe8c949aa9a4db4966b0e6aa6094b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9201925f6b5edc17777f98172574f73eebaac8f2f477654e27504de8207a0287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7060a3124e4efa4d415c38b87850dd90353b58a5ae6c2b2e7af49de538558b21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"oauth2-proxy")
    (etc/"oauth2-proxy").install "contrib/oauth2-proxy.cfg.example"
    bash_completion.install "contrib/oauth2-proxy_autocomplete.sh" => "oauth2-proxy"
  end

  def caveats
    <<~EOS
      #{etc}/oauth2-proxy/oauth2-proxy.cfg must be filled in.
    EOS
  end

  service do
    run [opt_bin/"oauth2-proxy", "--config=#{etc}/oauth2-proxy/oauth2-proxy.cfg"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    require "timeout"

    port = free_port

    pid = fork do
      exec "#{bin}/oauth2-proxy",
        "--client-id=testing",
        "--client-secret=testing",
        # Cookie secret must be 16, 24, or 32 bytes to create an AES cipher
        "--cookie-secret=0b425616d665d89fb6ee917b7122b5bf",
        "--http-address=127.0.0.1:#{port}",
        "--upstream=file:///tmp",
        "--email-domain=*"
    end

    begin
      Timeout.timeout(10) do
        loop do
          Utils.popen_read "curl", "-s", "http://127.0.0.1:#{port}"
          break if $CHILD_STATUS.exitstatus.zero?

          sleep 1
        end
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
