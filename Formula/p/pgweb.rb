class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "4120b03ee5047d8ea5bc9fd05629fb60bbdf5eca6a0e8b157fa4322ed54844ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "797a6578aded844b296169c74045b4735a435451bee8a6dd9bbc27b6a7955fc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "797a6578aded844b296169c74045b4735a435451bee8a6dd9bbc27b6a7955fc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "797a6578aded844b296169c74045b4735a435451bee8a6dd9bbc27b6a7955fc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "619152d700dfe8d083c8575d8f26dc2b026380d0c2ea8f0b8719cac147e31c08"
    sha256 cellar: :any_skip_relocation, ventura:       "619152d700dfe8d083c8575d8f26dc2b026380d0c2ea8f0b8719cac147e31c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c65033295bd08ffa0c3cc4d6a30b17ae7b62b957582ef0ae9689b9c5ddae332"
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
