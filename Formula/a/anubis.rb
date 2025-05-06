class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "461420249c5860cc1caed87a750c2eba3a02b1102833f3588feff75c165be78e"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d16c7c54957af0e6df519e1f70623fb2c809a3239e4d6c7d12b693b80ccd4116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a6e4f55dee590269a8db88fd19d4868912e6e476f7a19ff183e9aae5058e4d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a707c7a1be3cf9fb790ea6caa3b742f677a8e7ad2e6e1441095373aa215cf26"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd503408e8d61a901cc98a00bedef219a62158b6332a5457a5148159e3d03267"
    sha256 cellar: :any_skip_relocation, ventura:       "cb4662c1144f6b30a66534f0aaed7e93acc61997b38e9781b74e9c348e308048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d975ae62abe5d184c1581e8c1b7aaf4fa6bd499331734ff0198a056fd25160ce"
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
