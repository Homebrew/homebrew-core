class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "a7b8fed675deb2585a7751caefea457005d846a05ef6f5fc0f2419693c00d678"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2211e6b6502c41dd5fc0c6a2676050c6f91f621c169effb80e81a26bf26f9965"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d65a937abb523e9b114d2ed65efba6c358657cd68016ff1861be37dcdf69bc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c927116bc136769bbbbec15ecc5ac0b53c3485949038d9be623a8d65bcb747"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32fa71019c675cf01dffa9ff5fc619016fa3b9b8b2c1cabc737cf6fafbef7bbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed3379344e5ec7af017eb02062b21c3906f4c280fd1e6982ce7f632bcf08b7a3"
    sha256 cellar: :any_skip_relocation, ventura:       "6a5e15acb5c16f7953658d62adc9ed630c544d7d1fe45f89e6d02c28cdc8d4de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b09dae0f088230fce50061b765e14670918deac828d5ecb76e9e09644e56b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef17f1e143a3f82ca4a9291e51b6490a1dc0564ad5972f9284261fc48c2be72d"
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
