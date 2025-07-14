class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "1c3dc09c88712519e1c59e40f1d38b121ff3afcbcc0b6c4983b4a4940c91ad8e"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ddac9a9686675adbc38dd02ff5dfdb61577bf4961f073dd525d9a62b373da70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db67800399a684a0231dab592767570b99258df5e4ebf678d434e40afe836659"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a7dd571eeb2ac3e20a5b0c6a97375e40255677b31779e9c9a471ff6e6944dd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e016c0a1645c2d4dd62b88ccc8a984a632fcf7c877c477f348eb85cc8c13eee"
    sha256 cellar: :any_skip_relocation, ventura:       "a571325851b18ad295e4dc44a748173672e607a4f5924dc5f2779597c6e7aeba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfd484e116ad4e4a2baf462725bc9c4600c686f1550691c72af73257556519b0"
  end

  depends_on "go" => :build
  depends_on "webify" => :test

  def install
    ldflags = "-s -w -X github.com/TecharoHQ/anubis.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/anubis"
  end

  test do
    webify_port = free_port
    anubis_port = free_port

    webify_pid = spawn Formula["webify"].opt_bin/"webify", "-addr", ":#{webify_port}", "echo", "Homebrew"
    anubis_pid = spawn bin/"anubis", "-bind", ":#{anubis_port}", "-target", "http://localhost:#{webify_port}",
      "-serve-robots-txt", "-use-remote-address", "127.0.0.1"

    assert_includes shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{anubis_port}"),
      "Homebrew"

    expected_robots_txt = <<~EOS
      User-agent: *
      Disallow: /
    EOS
    assert_includes shell_output("curl --silent http://localhost:#{anubis_port}/robots.txt"),
      expected_robots_txt.strip
  ensure
    Process.kill "TERM", anubis_pid
    Process.kill "TERM", webify_pid
    Process.wait anubis_pid
    Process.wait webify_pid
  end
end
