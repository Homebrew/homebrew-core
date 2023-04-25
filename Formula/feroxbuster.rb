class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "10e9ac6e0496c97c5a983d4431be05451e0e5c682dea04cd1a8842e563773a0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cf59bdf07f812bf083de88c2600ef113c6d56f8bf3304f487c9c4ff9d62e6ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5b27681245609309a2cc99bf930450721cef19d7e27503fc1cb6f80721de4cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "957220877bfbf63d1704e8ba0f8d05dd922c1fcfd66f0cc439ebc4ca95c67437"
    sha256 cellar: :any_skip_relocation, ventura:        "d18c3d11e02a08f17c4718c426bb4b7cb0a8901b000b2d0ef58d214ad530cc78"
    sha256 cellar: :any_skip_relocation, monterey:       "a0887e5f6c665879aeb546328772aa9d7a32021539c438c499a94b0056535669"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2004a491ed1954e6473343f9402daa50bddef3b8fb26098ef8e0992e4f2b6ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a70115f2804449c8cafcc61002f953e44c86498dc4b9cebfe21bfc15b45c033a"
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
