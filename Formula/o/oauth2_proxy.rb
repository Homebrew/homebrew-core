class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.13.0.tar.gz"
  sha256 "86d005585f753cda3495cf68f231bcb3be13d7c96d80c8890c0f9939e0bddcad"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f86bf18a5897098ef96e16577d35121b6931b7b80153ce0805c7dd034f67432d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e92f0af0553a5607efb02eadd04e274ffaab348995e9ec40ed166a485b1f72d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e2c8ac95c58bad8a49fbc2fdbbb41407b0b59361ed726e7a1b2cf0a722d6991"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a1f93ba92f7b70f06b17311221464107f16dfc0300ac2811b22a2be4cb76e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5669bfc7396ac777fe122e986cf90f1391b53ee95ff5c0bbd200bd9828412c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f39fb2b7c2b2e06cf7139c71c9cb79135f9a187b6e61b27da8c0b4ddd8bb8b53"
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
