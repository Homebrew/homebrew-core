class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "8b2dce152312c895ddd06c370b7e7c74a5971a291e160a607716c5857bb5ff38"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28d742f20bfbfc2fef27d34ad1643d974c9a0c983cc8af098021146cf5030a2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a005f7a128680763d1ccdeaf2828808a9575d28529b8ecac01c5c8fa0c0837ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b253cc9857b0000eb85204d26cf926d68d9754e21f6177bc83df6129a24072c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c199d733874ec5d18545d2525c91d5879826e8d4f601f5f39b39ab3df709794"
    sha256 cellar: :any_skip_relocation, ventura:       "0854c1b08ac87abc4c9fc4679836a3a4c11818ff44242b53d0080bdfa2218836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fe211b40d601ba840a7540653074bc588f9999f6bd517eacbfd7470efab0499"
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
