class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "1b0c5d95c9916121be26810c4fca0068cd338d072aa41c9f853ff84d3255d433"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "266086e81f3805e4d8c22eaff154661568870e8afe65ae4c81c7dfcdc62a6c84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dcb5561f9a446b0bb483a4e95462ea62e3e092ca942c5536ad04f923f862d68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a26bf7b8090c584d5f5c7a9ddc5fababe950bddf821c9b8540dd9fd33e543ab9"
    sha256 cellar: :any_skip_relocation, ventura:        "7910bd9e4e93068db83736531dc63d0cfe16506927fd3f26d81008c6ab958334"
    sha256 cellar: :any_skip_relocation, monterey:       "0b5fb62144b4948520eda040e181a580a5741a3666ab010d304182f479651dee"
    sha256 cellar: :any_skip_relocation, big_sur:        "daecf794ec8565e3c5fa3119c37535961d07940446c0ee52c89b2c626ca46f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79a4aa34ba1d60789fd8acc8b1429029cf4e79377e835ffcd1357c8304f7d873"
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
