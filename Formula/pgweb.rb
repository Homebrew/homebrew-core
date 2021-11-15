class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.9.tar.gz"
  sha256 "2b93e8ebbb381e480c70a4c25ba62b7bb31a04e60be52951ddd874f603bd3789"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9119c191615e7b656cd56561be91fa6491205df19a7f744c6a206946bd6916df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8850d3804355efc5d38091e65d3f534526dfb1d054948f7204ebeafabf6cbe67"
    sha256 cellar: :any_skip_relocation, monterey:       "52c113300ac67f9baa714f347a32cf5f6b744527d307fa3a3c975d85ca4c7e20"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec49476c0f86d53843e63e7d0d19bce5a7f8db471bba1d050d0650bea83f8e21"
    sha256 cellar: :any_skip_relocation, catalina:       "973ebc01c360e25e1b88e274e93e6a948390eeaadd669901916aaffb91888d5f"
    sha256 cellar: :any_skip_relocation, mojave:         "94a5ede934e422a47e9ba408b6dd5ff7182ff4b69301420b220f4ec6fffdccfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fcde820a38532a5a5371ff9a390841b9013ba5a40e814002092a40061c98b78"
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
