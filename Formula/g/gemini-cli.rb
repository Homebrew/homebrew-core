class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.5.3.tgz"
  sha256 "e9b8c63145f23dd4fc637eef380d9b2769bcf1f7e93cf5868c19712594b40fe1"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "f962164fbe50cc6cefac07623d6df31b87828766ea4431f7e57ac73f0190af26"
    sha256                               arm64_sequoia: "031b11522e78e46ef6a5694379bba7f2c614f1b10ba9e591d389aeae69861ab2"
    sha256                               arm64_sonoma:  "41c7379030e8e8666e7eca8b780122504ddbab05c5f9c501388df08531ef86eb"
    sha256                               sonoma:        "73bfe10a70516b1c83db4098c4c67278b4685751d1bb1a6e2741fd252d1bcd0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "570a5c37c7efe166a4150ffb306deb555365b7d934a3837ae505726e5d0bc8e7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end
