class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "1d6cc31d5ce3bd21e8b58ef32ac5745f6684682278be4b905b229cf49990887d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d10158ff551d838481f26ef80f5a90ae643340bf6968d96b57adc62b06f9e0b0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e7cad76ca6438ee744b26fb8b18506e5b95dfeb4430894adad724394a591d80f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11cbc814e32b12539004720dc865b62ac5a0c8b1fafee4c25859982854ff60a8"
    sha256 cellar: :any,                 arm64_linux:       "98567bbf9e7e3270c17725118dfb798cc6d5ed5289a4d0f30a79357c3c3085ff"
    sha256 cellar: :any,                 x86_64_linux:      "237326dc35e6a5f99dbfea3493222d7170f67be93a5d5e619b7bbe05109d3051"
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
