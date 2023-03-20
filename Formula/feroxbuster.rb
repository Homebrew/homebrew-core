class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "c10b9667c738a0d70824b6833c2b8218591e8e827fddbff4a9d685f3284c7cc2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77553775b63281783c0c43080712c0b4bcc85768d5dc6c464431aecd5580fbac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7835783bc43f60049802d4e862272b4e0f96ae262dc3c9745ea14ea248a2885"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e23b235ceac3264af1d129c240417e644c8bf39b94d260289a5029c759d0ecab"
    sha256 cellar: :any_skip_relocation, ventura:        "32b08841dd0686be6d397e6969029f4d7df40779a446f1ca11642ef2b848b7dd"
    sha256 cellar: :any_skip_relocation, monterey:       "8f01aad6c2103a0562680b9974d7f30144d10b5053180a92e2318b14ba1e0c13"
    sha256 cellar: :any_skip_relocation, big_sur:        "70398275aed0bc8ac776a80f767ef8363b0c2c13c1c4987fcf896a085104f62e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "860a73d44d8a3ded342fb24d624d528900294d0362f952c9ac0191d5a2647599"
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
