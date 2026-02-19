class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.14.2.tar.gz"
  sha256 "e96c335299955043ca44d8b6e6c680acd5330c9265f0ab462a6d6de7d492134a"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b05f5feb7078f861f920ad31a910ffb72ececf56123a7af5c3d3c2794ddf9f07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee660aa40cc7ad638361b7e9f9852912456b24463f9ccc47e6f7ff151c37b0ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b539bdfe1d0d31bd085f6dee833ec1b778e71e3b121d9a13a6937d1a3d2dae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9463f67d83da418a4f5e44c06428864d7a0897e20bbe03fd2dc5cf4ecbb36227"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45e9102ec3ec65eebbc1415cebb7c45115b993f819c4d814846ce62223870e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d4500fb77afd27ef8ac92305cde6a7fd32826b3893cfdb1aa7130d5da08fede"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"oauth2-proxy")
    (etc/"oauth2-proxy").install "contrib/oauth2-proxy.cfg.example"
    bash_completion.install "contrib/oauth2-proxy_autocomplete.sh" => "oauth2-proxy"
  end

  def caveats
    "#{etc}/oauth2-proxy/oauth2-proxy.cfg must be filled in."
  end

  service do
    run [opt_bin/"oauth2-proxy", "--config=#{etc}/oauth2-proxy/oauth2-proxy.cfg"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    port = free_port
    pid = spawn "#{bin}/oauth2-proxy",
                "--client-id=testing",
                "--client-secret=testing",
                # Cookie secret must be 16, 24, or 32 bytes to create an AES cipher
                "--cookie-secret=0b425616d665d89fb6ee917b7122b5bf",
                "--http-address=127.0.0.1:#{port}",
                "--upstream=file:///tmp",
                "--email-domain=*"

    begin
      output = shell_output("curl --silent --retry 5 --retry-connrefused http://127.0.0.1:#{port}")
      assert_match "<title>Sign In</title>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
