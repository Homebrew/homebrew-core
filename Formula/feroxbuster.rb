class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/v2.6.4.tar.gz"
  sha256 "df2cfdab90d420d4de7e12edb665f0c0c3be7f5cb718b16e32106aaa9957a041"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17f6f6c8ce5d63fac03826d667681bcf75222810c8c87f6dcf5cfab23974c97d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46cc1654788cd599acfb4a24ef07c6b57accf4cef8c043f726bfebca060370a6"
    sha256 cellar: :any_skip_relocation, monterey:       "879fcf32d474061bbe4a32e8aec7a74cd944da76dcff9a8ceac2880595a3308a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5cfa2ca9d8aaa2c44300a4886b0a82708ea9ced1379346a1c522f9e35c768ab"
    sha256 cellar: :any_skip_relocation, catalina:       "2889da4559cabda682f7be24933e33f404603acc67b8b10e8d858cae4442904e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf7a57ee65608a5647805a7afc1ef95afb94586f46428c526247fd16ba757a09"
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
