class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "5a79b4a13f313f8b38d63957495bd6ece01ab28cf83e23b288cbb7a1b3dd7cfa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23107185892b8505ddbcadd2d8b65d27d70aa3967e70739bc5116076156970e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23107185892b8505ddbcadd2d8b65d27d70aa3967e70739bc5116076156970e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23107185892b8505ddbcadd2d8b65d27d70aa3967e70739bc5116076156970e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e90f55a950135a612407fdd3573b0b47fda4d4342242e6a0f5cb551f2fd0a694"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0670ea9a92e7ca6385393bb9ec4f661697e5cc4817920527811e2074e43d2a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b839a6b99f66db0edcbbbee6bc75189f3d281aaccd17e9f4261bc64676cb0219"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sosedoff/pgweb/pkg/command.BuildTime=#{time.iso8601}
      -X github.com/sosedoff/pgweb/pkg/command.GoVersion=#{Formula["go"].version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags:)
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
