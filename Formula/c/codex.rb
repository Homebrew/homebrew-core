class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.6.0.tar.gz"
  sha256 "b80fdd78d90b880ea650907b80af0e7b4c18f00050ac122e459f1033505a620e"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4b325043f6bbfb6f9e691d8889b0352eb11a830d5a79cb1e8c46b9bd2521399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "422ae057c33f2c9411dc41f982ede196837e1df031f3048ce68c16b0b93cd114"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12cfad2dabd5b50311ba886030a38d6d865a0407a0e9093fb3f4afdbbe5abe7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d22887730d1a5ea67778ad1193ff3b97731cde4423fe545fa18ead5434d4f168"
    sha256 cellar: :any_skip_relocation, ventura:       "b4a3586415e85ee1c546f2e662d16c05eef2b768f9a78a527a79999251d769f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31b7420f2a31a2c3f2a1d6f59e0d44ddfbe7c3bc7832cb305aa550c3f00c24be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5c35215f8e7c8f83c95e87f3e287182967101ba8987ceb0418427420dd4f20"
  end

  depends_on "rust" => :build

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
