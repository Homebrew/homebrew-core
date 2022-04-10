class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/v2.6.4.tar.gz"
  sha256 "df2cfdab90d420d4de7e12edb665f0c0c3be7f5cb718b16e32106aaa9957a041"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71589bc16bb70e3f38b17e6f65736827b3e988c128be2aa76495b496ba49a9fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a37d3f4bbe63e842d4a9113b166aa94fd6158f880680fb60d456383ffddc587f"
    sha256 cellar: :any_skip_relocation, monterey:       "fe3f2051beaf387ebbc66834a31068c67180af20db097ff57cbe72e9aee99693"
    sha256 cellar: :any_skip_relocation, big_sur:        "a721f836542fa960f01c9f07d434ac261c892a0d4f464e3e6669b8c64d06e62f"
    sha256 cellar: :any_skip_relocation, catalina:       "3f621e1a379366dc441eb22bc3db77916251eaa61af8d978a38f5faad82af6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "740746b94a45755dbffc65b02933cfac0b6c25ec5589fdace87d5e440202fc16"
  end

  depends_on "rust" => :build
  depends_on "miniserve" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"wordlist").write <<~EOS
      a.txt
      b.txt
    EOS

    (testpath/"web").mkpath
    (testpath/"web/a.txt").write "a"
    (testpath/"web/b.txt").write "b"

    port = free_port
    pid = fork do
      exec "miniserve", testpath/"web", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 1

    begin
      exec bin/"feroxbuster", "-q", "-w", testpath/"wordlist", "-u", "http://127.0.0.1:#{port}"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
