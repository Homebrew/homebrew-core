class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "55bf6d6ee6a1372604816b2bac08e7d6850f747a0c86bcdf9eca1be281feffab"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81bc0dccfe364179a4d85eb88444a905558711719d37f6de65fc2c70836b247d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22cc45cc4abc41185037efb28b37f12eb1ed3da41f297acc6749e376ad3a5167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a94c85651a045923e7d0e95bd4b77855ec2c04756b7574288cc413637921bdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d660357ec790c0abe3629ce8a113dde57fb3a7cc9efe7735756a8049bc4365e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48ec4f5756c54aa197f905bdca29904fff4b4ea90bbba731515dff065ee0992a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ddffe7933f8dd924b8f36bad677657d3e6af1b1d524f5dce886910c326f1338"
  end

  depends_on "bash" => :build # error: shopt: globstar: invalid shell option name on macos
  depends_on "brotli" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "zstd" => :build
  depends_on "webify" => :test

  def install
    system "make", "assets"
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
