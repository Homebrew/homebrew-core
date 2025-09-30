class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.6.1.tgz"
  sha256 "f94382e12d7af7bb3cad0c2f64445c3ef569bf08be540796d8d7ce87f2bd727a"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "4165149364a3724aae20eda7e21d14ef421f293b8279882f94060937c4046e8c"
    sha256                               arm64_sequoia: "b4330f46d063e7c5d53567baf56216f9fc53e7aa0880e4e48ca9af0fce8dd023"
    sha256                               arm64_sonoma:  "de6d92ee394debfa7b121215fdcdf2f8ddf3cb4ec1d8daba6ae5541781d2e13a"
    sha256                               sonoma:        "ec08a9c1f706aea69de305e2934c6b9735e098d214ba68c2873358f68296af83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6e11c28b25fd6c9a1e62de68c3cbcb2504aa017c69f2fafb9ef612ed2cc5e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "745132f856d5b55278f711b42c63f072eeeb6e7f254c42b7431f3ac6b69cf013"
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
