class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "c818ee856da6b873bc027db3e77209e08376b71f739231aaa65f4e04fa8c6dd7"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88e57050a5eea0fbbcff8a3940738b03217cce3641a76aa2eec190fd532999d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "487fe27a913a985948907a3a05d90b2f8bf7504aa4c37f88db0a59f0b7bacf4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d466ffcc5680933f5cc9fa8e8b4babbdce2de801b1342625a9483764cf35ab6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f27697537af3cd79e5d3f61eda97f15a312540c64b6ece488822a36ba143555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef3993e454fbf6e162ea71b065f07db4bfc0a9b6d810011364a85db817a50a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "727c67043fb27a109674b48087e82c171bd24e056a020a66fefdcf9e4efdd6eb"
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
