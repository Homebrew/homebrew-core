class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "0eaf51f4c7848d85d8059e030c9dba9d25eecc7fdad7e90806734e4af85cf779"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bee1d1308deb0c7e685170e1d4c3896c9739d0d3dd32fde3040f1a3a5c33d2fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7300dbe7af797ae6ac3acfb7221de524c6a30dbe6ff973d839303d84c5b21c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "903ba92e018d1d65d2db32b18184b752ada20a1edb6cd84d543ebf2cc284eead"
    sha256 cellar: :any_skip_relocation, ventura:        "3de931567ac2a14d4000e7c305f63857ba08692ee35b4f38f20859f7167be341"
    sha256 cellar: :any_skip_relocation, monterey:       "7efcaa0899fe86254434118bc2cc6610fc7546544993be9940290dc43da0a5cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "48b1cc0728e29a7ff9a5c878f9a87a0ed44f1f4663cc1dda0dbd2b4183d2f452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a28eb75ce1f595c706347a68531fe5510940da81f7ca9b1a11b619973cc54a8"
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
