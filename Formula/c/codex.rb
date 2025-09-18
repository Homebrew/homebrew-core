class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.38.0.tar.gz"
  sha256 "cfff8ac71ee388b57b363137febb9e923bc8732e2919d14e74228b6dee3546f8"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efdb84debc847196ca70996ccdfacb8ad7b13058a40e086fc224e708cfea72bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb05d1a1acfa1df0f03d7c0c7188437261f0c63d0af79e0af2af32c2f0b0a595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5bcaf59ebf5b9691e1a133b6199857f2a741f1357279028a45cb44235873ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "03168604a0a3dd19c9bffff4964d4f02cb54ec4e421c2eba678938ce62be0865"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "912aa63a406a98f00a5ea4f46453fd8f8bd8d92fc513d036a64b789dcdb29737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f4a93f7f92e27d3a4daaf24ce7c908c6a7022a866e489523a1fa6ecadf606f6"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    if OS.linux?
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
      ENV["OPENSSL_NO_VENDOR"] = "1"
    end

    system "cargo", "install", "--bin", "codex", *std_cargo_args(path: "codex-rs/cli")
    generate_completions_from_executable(bin/"codex", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex --version")

    assert_equal "Reading prompt from stdin...\nNo prompt provided via stdin.\n",
pipe_output("#{bin}/codex exec 2>&1", "", 1)

    return unless OS.linux?

    assert_equal "hello\n", shell_output("#{bin}/codex debug landlock echo hello")
  end
end
