class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "1d6cc31d5ce3bd21e8b58ef32ac5745f6684682278be4b905b229cf49990887d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39aadacc8e2b71f1f51f967612f8c17ae2d0d15d7686046c57d564c6351d9c18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3b5d4c06230ab1df92d7551894d3d6d75f746f602e03956ba7f612bb16aa3c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d092fa8ea2c9e0c2c0ff512e7539eb342a79f29c78162be9e880d6768c9d12c"
    sha256 cellar: :any,                 arm64_linux:       "9b20f6cef7334d9951d8aadd0d4fd183708bd0e2c0a251b8a653c4d5ae9300b4"
    sha256 cellar: :any,                 x86_64_linux:      "360dc98dc0a6b0a664a1093b9b82a1a3c122e10376e56131bd949f18e83f16ec"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "miniserve" => :test

  on_linux do
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

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

    begin
      sleep 1
      system bin/"feroxbuster", "-q", "-w", testpath/"wordlist", "-u", "http://127.0.0.1:#{port}"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
