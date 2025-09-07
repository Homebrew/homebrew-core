class OmnaraCodex < Formula
  desc "OpenAI's coding agent that runs in your terminal with Omnara integration"
  homepage "https://github.com/omnara-ai/codex"
  url "https://github.com/omnara-ai/codex/archive/refs/tags/rust-v0.1.0.tar.gz"
  sha256 "0a27753fe85876d62a3f4cff2cfd3c4deb6b3fad9727e3faa91cff9ed2f3c20d"
  license "Apache-2.0"
  head "https://github.com/omnara-ai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
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
    mv bin/"codex", bin/"omnara-codex"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnara-codex --version")

    assert_equal "Reading prompt from stdin...\nNo prompt provided via stdin.\n",
pipe_output("#{bin}/omnara-codex exec 2>&1", "", 1)

    return unless OS.linux?

    assert_equal "hello\n", shell_output("#{bin}/omnara-codex debug landlock echo hello")
  end
end
