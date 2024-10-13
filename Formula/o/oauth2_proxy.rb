class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.7.1.tar.gz"
  sha256 "05a849bb79a6cd160779982f5564c0551e20a08e4c4ff947882817cc638a516f"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35faa762083e9fb5ac3d59df3ae0a8ffeb2f29f7ad3c261fef224fee9559eaf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35faa762083e9fb5ac3d59df3ae0a8ffeb2f29f7ad3c261fef224fee9559eaf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35faa762083e9fb5ac3d59df3ae0a8ffeb2f29f7ad3c261fef224fee9559eaf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "57e0ac14bfef13b1d672490da45739fcd6894a47f02b67d9f3e56eddc2a71644"
    sha256 cellar: :any_skip_relocation, ventura:       "57e0ac14bfef13b1d672490da45739fcd6894a47f02b67d9f3e56eddc2a71644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6935b6c23732abf1745b78fa4069eb4ce77f2848ef293b3d155654ba2a67be6"
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
