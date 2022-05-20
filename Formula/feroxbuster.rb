class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/2.7.1.tar.gz"
  sha256 "4fc37897d98bb09bfe738067eb5889adff20e0caef70e4487d20f41ec920381b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f167fc2b4d9ae529107451fce0a51d489b71fcf756da7f1bcdbc874f21ddb9e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "545e710239f2893ba4e7727077967b0ec7059f375798c0bb3453afe125440f75"
    sha256 cellar: :any_skip_relocation, monterey:       "b39ac240e877471e009a2709e453e3cb8fe00110744dd37dc8fc588027f2f3f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "37ef97dd22f19f0221337642f7a486ff8fcc9227cfcfcc80b25f5b27b0154024"
    sha256 cellar: :any_skip_relocation, catalina:       "0ff6c797667e4b8d508cacf47efefa8073ece36b113200ace735c5f8fb3d53d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bfce064409d4aa3a43d343daa120bf06bd4ac53ffe894e8118bcf6a3e51d632"
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
