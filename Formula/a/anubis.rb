class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "81b45cf8d210927c6bdf81b4d925734b623e0c0c3f04f48c2034a85eea3bcd32"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda0554620ce6abeeb0a5777cc01c44b603ee1f713e8e25e1c46a7467941fa1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45806cbe1254a691d81c31cf0a95499da84d6bcfb1c3a291d19cf9ea0c4b5f24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dd17f5bdd7f7239c23dc2ecb55e43e1cad4cf361aed3a51f26a477b97ca289b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b27f521838be56f3a1b6b633232d9e04b0bf1661a65fba52057975cf7af7c67"
    sha256 cellar: :any_skip_relocation, ventura:       "5308a487c85c2375e29355a48bfce7e878a78b66f32d0766d04e50ddc59e7a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da635f17d9b9eb9cf997595642c42a427ce0ec8283b69ce6f346dc61c39ba98b"
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
