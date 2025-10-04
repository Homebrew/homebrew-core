class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.44.0.tar.gz"
  sha256 "b873ffd11f5f39148baabf0d070dd27ffe5dc9028d6dd32ee75a043b26ab171e"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f93ccc44619f8ec518736387bd06717ffe54c946ce528389719031e9978a2e2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ab8e65df003b87b67118fc88e2074e4f40ce163e988687262896187e008ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb979aeef80104393c73a47749569b437da948f21e3aa3882a65825b40fbc85d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2ec76b9cadc0c50b9c236ff08a0b6162429c2644df94af4c26dff9fe49d1520"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "031469bc981aca6b3b83076a01219eee88a10af7db593fbbdbf37b45e0e2449b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b9b6e8cd9da0ce5a29b300845758ec61ae1497d96810e5f6e2adc241093d3a"
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
