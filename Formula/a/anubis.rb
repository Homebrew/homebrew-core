class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "d861f92358a7b78d43d3b82f486df44fa3676ea38574f0a28d2d76fe16ae41b6"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aacd365093d8be1955150ed48eec50d3a7c217dc9ca6090287d6f2e4b015e04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a919758701e86908142ca47f15c1120242018f80cb6640fb12a552728376be6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a173a2e0c27a1ee846dd0fa6fb35e4590114d04e3323a5bb05ff527ce049aeef"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f119e2f8da2390b2bf11116d818028da7deb37f553423b9249c542a9a138cff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05dacd6802ba05e64c616b472fff7e7e1e535b798a536e3ad6473e627cf993e6"
    sha256 cellar: :any,                 x86_64_linux:  "92d09073e9b5de183a5c20e59f32329b8b0259d759e4867c2ba5f05320aeaa31"
  end

  depends_on "brotli" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "zstd" => :build
  depends_on "webify" => :test

  on_macos do
    depends_on "bash" => :build # error: shopt: globstar: invalid shell option name on macos
  end

  def install
    system "make", "assets"
    ldflags = "-X github.com/TecharoHQ/anubis.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/anubis"
  end

  test do
    webify_port = free_port
    anubis_port = free_port

    webify_pid = spawn formula_opt_bin("webify")/"webify", "-addr", ":#{webify_port}", "echo", "Homebrew"
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
