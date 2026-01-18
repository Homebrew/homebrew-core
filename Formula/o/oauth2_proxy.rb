class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.14.1.tar.gz"
  sha256 "0c8267d6e79123421d8e1487a5a79168df79b27a73480f595ef40fe4ab779606"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db49f910b73aaecd44527f9d690902b04a3590060ab460354918dfdc1363c58a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b9fe829613f2812646d3280a917356805330b6b20fb5b435b74caac33281fc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f39fc2cca79f74e27363502339a8caa30ae619b9b735480685d314b609925a50"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c9cbe78b8a3d88400a6ee53facab72d2e86d85072bcbc36ed0eef7ae9865fb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4647316844df9519ea61db1719979235f57c24769811bc62131cc828ac7370a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa77bc86450f14a71957382161417cb92fdf775e0158d02f3197f65d59cb9d98"
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
