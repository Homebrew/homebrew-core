class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.12.0.tar.gz"
  sha256 "72eddf28b2fd7dc4f841fac47a9376a3f660d3d467f1fc17e69badd14870c5f4"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09be6dda7b5946fe025ce5d8129733b9abd4981f7e3658d00a3e0e0c5308bbe7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ea4dcb47280288cc86c4c8a9db91c724044f65a8eefbaf966799bbc43d99691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56ea0e2993ee1c28aaf75b8f2c89963c28dc19f42e74bf059876d590e01f3dbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b7f25b4651eb613fdd72c7c2feb1d179f3bc0b3696d4e5f7898c874fe50f629"
    sha256 cellar: :any_skip_relocation, sonoma:        "60cdd8f32912f026b1b4d79d65c6e26ab4d083cd6ac99dbd0972938d1785c122"
    sha256 cellar: :any_skip_relocation, ventura:       "4a47b133a8e94537de109b52b32dd4b6d61addc31d402ab153959619d1005335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a332ed0f0b04571737bf898e5201351f93bbf1a098e87c4aa28984462b1d9e"
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
