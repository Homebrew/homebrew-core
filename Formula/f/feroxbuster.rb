class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "6f1f3466319ea5485b9d6f05000718c6ccbe1210c1cea7b2af83a5343d068a23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf3d55e45eb9afabc85f7c67eae77c6709d1fc4a8185778623123a80122c6c28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab47077afdd89da24c43701285b8c72907793e5f8c37c45937d658477468b78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48a383c603dd30adc6c913746686c4e7ffa734b7a5891e0fa26ec70a7e3d763a"
    sha256 cellar: :any_skip_relocation, sonoma:        "71c0e2331a9c2181491888c1bc1c76aadd6ee454fea4c872115ae661ea2abd19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2352ef2c7a4f221b5ab323274e35ff40793ec3d787a0daf8744637645b7467f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20afd4144eff9917898c9708e1073c071c27a5a8b4dfff6ba65f211b86862c9c"
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
