class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.7.0.tgz"
  sha256 "a9cc6e57d470158b533b564f746f2d7409308870567ef2c9efd9b3a66b916741"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "f3fc94964201c2d4a89e3d85b8e807578b471f4360cbb917d0c92f1e39e85d3b"
    sha256                               arm64_sequoia: "47c91f51204286b7d2d1175eeb4d14baada3081a30d07763128c73c93b4bd058"
    sha256                               arm64_sonoma:  "b756ab8a1ce546f6af1dc4ac84ff59dde3c440c5ebab46a917b927fe8292bace"
    sha256                               sonoma:        "3bb56ca3cc5014b032949527e02832a5297bd39e1687eea1415d0d6f4f9c585c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee3835bccc5f1bfa57662a864c45061e3141555d29d48fc55edb223cbd934550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e66353a3695c77b10f0d65a2318c5a8c7c70555ebc3067d5051d4331c7327f3"
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
