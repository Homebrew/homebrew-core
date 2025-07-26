class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.10.0.tar.gz"
  sha256 "025c696a26eee9071f35adb48ed6ec9766431a202fa19425f4e1760f77bed108"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbc4704ce9292bb6449b35ff88353d23679d0fe4d682cc83f1d696e373478b17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f69dc112b4aa846af83bd56bea401476bd10ffff17777d54ed3d5aaed7d74c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "140e9e04908f05b3af1b0045be8daaae897ad2f51c7d5062d4a1c0c44e254cf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6b9596dcf1c6bd1381ba06d232ec3d3bdc64bb7aa2fe525430b18bbc1962efe"
    sha256 cellar: :any_skip_relocation, ventura:       "f01d75d420265082d96fb49443b3c452eb475e1a69accab9c9ac3d5b087e02ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aa32bd79e3411f0c6a4a66cf4f74b737e9fd0e94175039e7e46d17572d9a6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f39f47dada6f850b2eb63ad88ccfd03f7c8a060d76ab33b8173a47b48b181f3"
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
