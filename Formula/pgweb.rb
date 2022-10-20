class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.12.tar.gz"
  sha256 "f35d1bdef96c82b417e321856b08168e3aebc39d132548926251599d7ac79226"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469869de47ac0c2ee4693bc6cac59845ec26c2946b95fb04094205cbe8d5ea69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e23d33b4ad286ac2900d12083682d4416dffca3edfd051ed74db027b33cc35f"
    sha256 cellar: :any_skip_relocation, monterey:       "31952522ec9bcb9e927c468c5707b1c4a86902bb22291302b82a192ad62eacfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1341993aa9c33b45664ebcaf12a2a94e26b64489910342f7deb728cfb775f41"
    sha256 cellar: :any_skip_relocation, catalina:       "de33b7ed61feaae3a414c33a60d559f5b6ce94e50597fe3ede7ece6d60a8718d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c5b6983a4fdce18360610f371c3d609aa4ff3b56b9399ea2b8b0ea78304a92"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sosedoff/pgweb/pkg/command.BuildTime=#{time.iso8601}
      -X github.com/sosedoff/pgweb/pkg/command.GoVersion=#{Formula["go"].version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin/"pgweb", "--listen=#{port}",
                          "--skip-open",
                          "--sessions"
      end
      sleep 2
      assert_match "\"version\":\"#{version}\"", shell_output("curl http://localhost:#{port}/api/info")
    ensure
      Process.kill("TERM", pid)
    end
  end
end
