class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.8.tar.gz"
  sha256 "b391dee6e88c534db82d71515d7efa642e6a34bcded93250fd3f8c2150e75cd9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44278bc4332ff3f952272fd8a9ddbc3ea33f540c869e41e168245c942e0c1ef5"
    sha256 cellar: :any_skip_relocation, big_sur:       "e078e2a62bdd3c7d203895cae1c0fcaacf8b26a9dcd40d1f88b760667adc9d1d"
    sha256 cellar: :any_skip_relocation, catalina:      "38ad603da0bc035e5a905f44e22e70335d965a4ca62a2019d08a03cde3fe7f8c"
    sha256 cellar: :any_skip_relocation, mojave:        "7230e2f2ef476b2768a25796c3f20d45654eb8fa33ff171e70d91188df7e6527"
    sha256 cellar: :any_skip_relocation, high_sierra:   "536cc0ae5680a2c6316c569e2989868108f4b6626e496ec99c93e1ea823a7ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16f88cd19d5e122e19d5258c724726d154e9bcece00de7b84f64d4273165c91c"
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
