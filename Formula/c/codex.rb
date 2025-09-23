class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.36.0.tar.gz"
  sha256 "20968c66f6cc23255dc4f7a6959851a7782995fb961b94fccceeff78d908c10b"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13eff0ab27b593602ca8283309e168db4ccd0734abe868cffa7cf0b4d51bba0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "563acee739ac379962879329d01f4a1c24005704cd50b8d7da687a014563d758"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f18b658e6eb86cd688669cb51d24f214340071541abdace2cafce155ed479b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "375cf8b3c2db5f2b8d28c75cf13f6dd5b3769a6e8f00e67d067770bb0b7431c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17a76768f2ad80fbf960d51d8d5f416eaeb514b21c03c149f2d84a14cc82d7ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dcdbb07560d315bbcd2099ad7243961968d75df608e01c3f417123f911699da"
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
