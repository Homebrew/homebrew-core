class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.42.0.tar.gz"
  sha256 "e0ac101e004f6aa7b8b88d23e822e4fc157e390ee1646d435b06fd1a1e5378aa"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67a02ce8339dc2fadcb4a3ee057275524dfa6f5941ff49da91ee638b4cda1baa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58556a29f9efc5c9c8289a6f48d43d4ba02268bd2100fb311e6a56f673b830fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "037dab449b1ee8175e70dcfc144f18181fc87bd333225c1d8f0c2746a3a3217b"
    sha256 cellar: :any_skip_relocation, sonoma:        "814e829ffac044df4c951367badc3f69dab7d23efb6aa4a457d167e4cacd5066"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "614f78f9b919a0302c5b81660bd5b4e1364d931f26ef04a8fcddfb52a82d23ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b07f80c7e7f24f4496f928513ed8273db19c1ec495e573a54e49400c1945839"
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
