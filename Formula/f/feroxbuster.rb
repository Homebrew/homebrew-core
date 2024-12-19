class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "61aa0a5654584c015ff58df69091ec40919b38235b20862975a8ab0649467a83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51c6011f5593b6dd2012fc7632e03443382dc34366b49fc197bd85c72ac84c14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b289fbd75851dcf2c824f86931ff583a106797ed7c4aa092461227b9c574d9cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2983e54b04f2de0b30938fcee493c5786dbadc4a6383191c8feb1433b0d96eaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "fda99a1eb698b711a85c1ca4ff35afc21e42d840c7dab87c5cbc73eb0a62acfc"
    sha256 cellar: :any_skip_relocation, ventura:       "a95cc0009963be0131251e81639164187a31c869ae4f11c76f033045cc30a33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c31b3b1589aa43597612d07fcb4c1c2386473f82dcd91ef6e64ebe05338209e3"
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
