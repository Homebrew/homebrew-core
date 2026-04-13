class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "e281562dea0b49d0639c3c5e9b0a2a7fe522b1a359e3cec470db06493835bbe7"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9acf178b4a331b463edeb7672edbce48d993665ba6b47af2cd20977e0bf7f65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "673347ccc53830891b3ac4c9a49c5183b1668777664de1f8a16639ececfcc04b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dc6689df677b524f2968523f9f40a714602f8ac3335ff480813243f11b876be"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c52c1e6911cb7eda04e793cf546e8113b75052162dcf6714154cc4c2f63641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36e0b479bd36da7229c6b3e272b21a49b4b161f9f7b5d9912baaa1c33d8d67f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "798c2f328cdb18c3434120e2568a982a1658e1fd5dd360fcaf2f23cfe2f3ed09"
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
