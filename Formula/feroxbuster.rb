class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/v2.6.0.tar.gz"
  sha256 "1ae40601a26b8efda690e59f822d159c0be2cf3b1e3528d7fd8925aee5342fc0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d835d2cb3c9361b19eb17fbb582a47e6676c44243629ed95fb3882bb63b4bd41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42708949a32a68a2a75cb951c0f89a58bdc603e12a45ea2e56e0457a6abe5e03"
    sha256 cellar: :any_skip_relocation, monterey:       "3cf391d96de0bd291d786df340cb7e1657c25f7133f6b7840f9a0be53447a378"
    sha256 cellar: :any_skip_relocation, big_sur:        "4eaf2ce3f2d1f87de147602c56b7c463c0d67d64eacf42aa3ed7a4e4c6a9fb76"
    sha256 cellar: :any_skip_relocation, catalina:       "faa55119e22344b7bfc06267faf20f5c5da0a99a7b1f71ed0dd9de1d51e6bf20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d84458b71cec3aad074232c97c765e015bb2a72203fac35aad2e3021e7830ea"
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
