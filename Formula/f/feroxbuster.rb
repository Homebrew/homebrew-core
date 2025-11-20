class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "41b3131870c07e3bb93f769444c1e59d3ec370a1c7195bf8bfa192ef179bcf01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95e78aaa0ae74a6fe25a19776aa739616c74b67b23b84468dac101d2b4b44b80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba73b57bdcef33fdaadaea5f6b79127cf5cd525a9665076da381e3f6d6466ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aa8747e2c197f0111baf30ea0233bd8c93ed05e2c2de3ca000d5b49b17e8024"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bf6438f6fc75f515ff88ffbb9e69a596b447734e999d79943d745a9506cbbad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "494023a21a90bd45c10b49b9f0d53a94e62bb826328bb8d07928df9f0939be77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97175185099c811858825eca8eff095dd3d8a890bfb73d1bd0dcc5ede1de0902"
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
