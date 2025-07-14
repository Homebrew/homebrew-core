class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.12.tgz"
  sha256 "748d7c8b4a47ff2562f08514093a989111e6083dd322b6c32599a6c03ef58d51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fde98ffaaa23b792f3290e9c593e00ae6175a573b9e535cc7da3d21994c3b005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fde98ffaaa23b792f3290e9c593e00ae6175a573b9e535cc7da3d21994c3b005"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fde98ffaaa23b792f3290e9c593e00ae6175a573b9e535cc7da3d21994c3b005"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff9e477a4199c088a37a5a5cfb1712131c24e6bd5e2afdad55b9b673a1272dd0"
    sha256 cellar: :any_skip_relocation, ventura:       "ff9e477a4199c088a37a5a5cfb1712131c24e6bd5e2afdad55b9b673a1272dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fde98ffaaa23b792f3290e9c593e00ae6175a573b9e535cc7da3d21994c3b005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fde98ffaaa23b792f3290e9c593e00ae6175a573b9e535cc7da3d21994c3b005"
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
