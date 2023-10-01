class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.5.1.tar.gz"
  sha256 "97de086ba98ce884da77d4031537f72496a059d14c60977c46824c24010096c8"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09e38835e404203559311558a7205f57844bfa5fae1f03b2dea535dde82d51de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79c2131dbf92a3deba0c0d55bdd038377437400bb278702a3c358baf438fc162"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efc245492714e5ad2b018657d808acd19f8aa181c3d84f15ba333e3a4c0357e3"
    sha256 cellar: :any_skip_relocation, ventura:        "3aa7b4203cdd1edc6401ec3250e97e928c0338a7c7186b298fb436272e401da2"
    sha256 cellar: :any_skip_relocation, monterey:       "ee90e11e224739522e8fd59448e9ae6a13e7725d6c65a2eaa11d0fa9482851d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0c6f546f65ff9d15eda15b9e2ac246f53b651b6e04fd40f5165ccfca117937e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b446ed3f8684266bb6dc7dac826f584bf1ffc9fc026186c4ecf51042d8babbb1"
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
