class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.17.0.tgz"
  sha256 "6092c3f809ab36da42f7e480eab655f2e7e656a00c01098b4b5d20583bf3c550"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b079d8d646668892e82ee5641aedc2a7fc109d0015efb52a802733ee5271b80"
    sha256 cellar: :any,                 arm64_sequoia: "81794cd68a70c0ded7f1618e82cb20da3227995b721be7ebb619987e94163e29"
    sha256 cellar: :any,                 arm64_sonoma:  "81794cd68a70c0ded7f1618e82cb20da3227995b721be7ebb619987e94163e29"
    sha256 cellar: :any,                 sonoma:        "0c829c6c27d797ce93f8a6586554328ed43e925ce7df5908d5cd06a2e210dc0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a24375d683664ef91326df7f2a7547f2a8d474d78894c7df561b4fb9f8af377a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "387cea50baffe1395e197f906fdbb98cbbd044fb1094852ac4ff9af4f93ce59e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # https://docs.brew.sh/Acceptable-Formulae#we-dont-like-binary-formulae
    app_path = libexec / "lib/node_modules/cline/node_modules/app-path"
    deuniversalize_machos(app_path / "main") if OS.mac?
  end

  test do
    expected = "Not authenticated. Please run 'cline auth' first to configure your API credentials."
    assert_match expected, shell_output("#{bin}/cline task --json --plan 'Hello World!'", 1)
  end
end
