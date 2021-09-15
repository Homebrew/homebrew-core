class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.8.tar.gz"
  sha256 "b391dee6e88c534db82d71515d7efa642e6a34bcded93250fd3f8c2150e75cd9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f12b6b5957c31af8f22c5ab8df4fa094ce594aa15207f0d29f2a390499ee96d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a02d31f0e35883aa3bf87d2644f8d2388bb93c5009c91c59bfc04382bd4282c3"
    sha256 cellar: :any_skip_relocation, catalina:      "4f8da0cec857035c52cb0d867f11dfeb9b25713079f4d5b1837e6123ea741f47"
    sha256 cellar: :any_skip_relocation, mojave:        "ca983073d0229389be16276d51550a2d2a52cc9fa80dbddeca1a0821d790e989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f712d2198798bca0e0788f6aa65a9d95bb2b609f34d53983685b7153341a21e3"
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
