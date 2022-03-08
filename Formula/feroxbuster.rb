class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/v2.6.1.tar.gz"
  sha256 "ce14d03a24212ae544ebd7217bc875eaa5fd4396dd11ae06ac707ef4e14c9690"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfb19a47e4264f285432c3b486afabf416f819e791dbe4c6759f9aff7ffab705"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52feef88e3b8a0cc82d2008c0aab972d32caedbd8c8196724202eb0fae52576c"
    sha256 cellar: :any_skip_relocation, monterey:       "11b18483ba667548dadf6355f3cc79b6609e506ddabdf9f124b918e07fb48aa0"
    sha256 cellar: :any_skip_relocation, big_sur:        "58a19cbcbe65f75171bb7a0dcc3e96b967e3737670ccd3a1a498835ee28e58de"
    sha256 cellar: :any_skip_relocation, catalina:       "f151505ed1d61fe1ad4d7a508558eec3f5b4acc401b19b51e4214908f2576ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dea2f198f2bc063a0b30fbe5a9c33f8509578b964a98d968c7c583f25a84c437"
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
