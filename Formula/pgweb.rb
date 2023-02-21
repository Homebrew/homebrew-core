class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.14.0.tar.gz"
  sha256 "801f83449b88ef241a30f69d5c4201adc295f4393182cea195e51281c6df58e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f2166f14974abbb9e66c07c5eda1ad7c510111249d1252b7dd6cd8635ae020e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3e6b2a7490131fb93d515e2026be78478e844c284c99c87fc10a39d1b609a8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e018ae2cb5bce8cb004cfe69308d642d96913ecec97037d8e24053f89ba2f86"
    sha256 cellar: :any_skip_relocation, ventura:        "957d99827a58e57b9188ef148baa696146ee90dc14b07cd22d2d7c03fe69901f"
    sha256 cellar: :any_skip_relocation, monterey:       "fb60f3b7169d889668c20f89e5ac54876c6d3f7b6d92cbe9752d881e497985aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "c98972f5d06728a7601c134ea6dbcef231aa45eafd7cd7e960c01937c6d19cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f31b67ba65c30b05491d6a3ea89fa6f6511591866c317160873bc121cac53815"
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
