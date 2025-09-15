class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.35.0.tar.gz"
  sha256 "518d36c0b4ed4af3478b18eac4ae984a316970f383b90408541125853c079703"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f2f12ae4639c4326e9b188e19b26893820571999087c586265afb29c16a57a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c9e4348837a8a918df875648ba753feccbb5a95a5dc80c038bffc715e0c0994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60c8a449d58cd275f9eba6b1128212b2ff58c1db234c5b4d56f21f09a84fd8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "246dbb3625beca8a6d70e8749f0a267a78fa0362360c047d954049876bc642fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce8593e6502c0392749a3156e23484a0a8a3b2f9847118b43c558afc15bc219b"
    sha256 cellar: :any_skip_relocation, ventura:       "19770f16309385ef0d004c22e3a38745a4d992abe85e797e21ae60b9a897b90d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3b5a18c020e52f4a269101fc44fd93d0fa0c2d1a7c9e7a8cc64ef5e0230b8fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b50c962db805b7ef92350831add8a4c2e6e6a0dbba9b0ad8234f3a0a0c6a640a"
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
