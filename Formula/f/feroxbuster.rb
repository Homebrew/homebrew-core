class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "96b70dec92c4aa4e892fc88696cb939539aac758c6762f53c880e1c21528737c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce1e83ffec2ade9627c627474379cf484f660eca0d3d1a1c3135bd922f0cfc67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eed0dc69f3f862e96043263cbbaf68a3859ec9f0600d9ad1459605abadb3fa36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f849fd931655c6465776630e8459ebd7a817aa6c1cf691dd824b30459ff1fdab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0013c0046693852292b140c1f3f9706409047eff93010123d5c041c7e97afcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ac27e2d0d21e734a49e823328278f38eff3fb5f3ff0b90b8754094b29e94752"
    sha256 cellar: :any_skip_relocation, ventura:       "0eaa992c22eb1c96bb4489a7708626a1064e02014df3c0b8e8e069795ef5948d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f120141f716ca7c7451eb4363940f31bf135e3d663984c9adf754c87aa0d1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78b2e4b0b484e40bb328e9f1c33f6a1859a62835a48b808cf2bc5fe31f7a5840"
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
