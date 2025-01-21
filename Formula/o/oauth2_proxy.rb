class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.8.1.tar.gz"
  sha256 "047e054e0bf690543711cfda9b9f02ef5a52fd46586fb2ec4613711d3675d808"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4995279cb3ea6e2a897397fd9b110e5c2428b526ccff077cd197b7845d63085"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4995279cb3ea6e2a897397fd9b110e5c2428b526ccff077cd197b7845d63085"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4995279cb3ea6e2a897397fd9b110e5c2428b526ccff077cd197b7845d63085"
    sha256 cellar: :any_skip_relocation, sonoma:        "82677377d9f3d56cabeff1569aff9797a4f8565a18cc4cfcfb4e097681a7552e"
    sha256 cellar: :any_skip_relocation, ventura:       "82677377d9f3d56cabeff1569aff9797a4f8565a18cc4cfcfb4e097681a7552e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db1e56a64f604eca68210699ea5081107733672872b563f91b5371fcef1a1c3a"
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
