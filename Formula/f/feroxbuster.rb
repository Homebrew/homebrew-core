class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "61aa0a5654584c015ff58df69091ec40919b38235b20862975a8ab0649467a83"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf7ba7b09be136c65b9610abeb3917e70c781f5ca3f14ae302713f5a0b0a743a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c37f755e0d771161924c22ba8db0da37f83f83034075a0ba9270a9e9f04debb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b746842e75d6cc9bdb53e1f1b2d8f48ffa91b1acdda8149f83ec680b60f35ecc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cb614702fcc971ff1ab5815cf9a137dbef994485b0006b66e74e63755376486"
    sha256 cellar: :any_skip_relocation, ventura:       "64a1648df0882c5a32d4b25dfefe5c61e0963c98996ec27a6916c540555436c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9182fdb77606f6edd070a4a4eb464d9a87e87caf1ffc362331e04240035a599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be9cee6c81ad2baf75d4380012c5d4887c6f66a51a1f699e47208beb3e41f44f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "miniserve" => :test
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "shell_completions/feroxbuster.bash" => "feroxbuster"
    fish_completion.install "shell_completions/feroxbuster.fish"
    zsh_completion.install "shell_completions/_feroxbuster"
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
    pid = spawn "miniserve", testpath/"web", "-i", "127.0.0.1", "--port", port.to_s
    sleep 1

    begin
      exec bin/"feroxbuster", "-q", "-w", testpath/"wordlist", "-u", "http://127.0.0.1:#{port}"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
