class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.7.3.tgz"
  sha256 "06428384d9a1feab0328e0c6ebcc0f1bd9eb37b52297bc9538a4a302d384df52"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "217440c970a95306d603b87490d7931c057e6812215d2521c263460fb5ccd0a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "217440c970a95306d603b87490d7931c057e6812215d2521c263460fb5ccd0a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "217440c970a95306d603b87490d7931c057e6812215d2521c263460fb5ccd0a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "73bfade8774c09692cfd38ec7360f4b709cbce48ab457a2172988ff4a07e6816"
    sha256 cellar: :any_skip_relocation, ventura:       "73bfade8774c09692cfd38ec7360f4b709cbce48ab457a2172988ff4a07e6816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe3c5f9781206e0c0aa5336c3984255f3aa61b55d156856a47927cc8b39178be"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
