class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.14.1.tar.gz"
  sha256 "e6636ff079c8b01ac2add78c7a05f86d61550a5213155065c892015e6217be01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73093fce59a7f8815216c7ee4305e8de347cd3fb954da693c9e7756e6370e210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73093fce59a7f8815216c7ee4305e8de347cd3fb954da693c9e7756e6370e210"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73093fce59a7f8815216c7ee4305e8de347cd3fb954da693c9e7756e6370e210"
    sha256 cellar: :any_skip_relocation, ventura:        "959a11dfa202fd1ef99fde030aec2d86e54db11a1f5f871c9a2e65965af604aa"
    sha256 cellar: :any_skip_relocation, monterey:       "959a11dfa202fd1ef99fde030aec2d86e54db11a1f5f871c9a2e65965af604aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "959a11dfa202fd1ef99fde030aec2d86e54db11a1f5f871c9a2e65965af604aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198b8cd7f8cd609dc113eff8e92f09bd78c3b555095f4a17f27c0496b60aee3a"
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
