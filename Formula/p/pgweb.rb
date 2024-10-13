class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "4e8bedc49c5bfad0223cf720568184a503d89f06820503c24c62fb404b929062"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7a638f814a80bd6bd2f3220252079f9cc9f839e3dc1d37f45b894f704481bc27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a638f814a80bd6bd2f3220252079f9cc9f839e3dc1d37f45b894f704481bc27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a638f814a80bd6bd2f3220252079f9cc9f839e3dc1d37f45b894f704481bc27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a638f814a80bd6bd2f3220252079f9cc9f839e3dc1d37f45b894f704481bc27"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ea03767bc369c06d771095b2f6ccc49c33ac891a877a0bdc68b0067a4526029"
    sha256 cellar: :any_skip_relocation, ventura:        "9ea03767bc369c06d771095b2f6ccc49c33ac891a877a0bdc68b0067a4526029"
    sha256 cellar: :any_skip_relocation, monterey:       "9ea03767bc369c06d771095b2f6ccc49c33ac891a877a0bdc68b0067a4526029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e9829c3ab153b04e69f055ffc1c1fb8cdd91cab4299affb8bb4ce5c9f12e95f"
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
