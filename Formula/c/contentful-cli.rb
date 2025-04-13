class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.8.5.tgz"
  sha256 "30ffcc16525aa55972a7ea8bc9a55b42850702eed1c98508463966883415bece"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aff0187d3e6fa118f25507c3ab4eef58465363d04c667e18e6c4d429b1f58904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aff0187d3e6fa118f25507c3ab4eef58465363d04c667e18e6c4d429b1f58904"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aff0187d3e6fa118f25507c3ab4eef58465363d04c667e18e6c4d429b1f58904"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5c96063a23f618a13202f7ae8d952cb239d09d53dd512e97e40229118a93ff6"
    sha256 cellar: :any_skip_relocation, ventura:       "f5c96063a23f618a13202f7ae8d952cb239d09d53dd512e97e40229118a93ff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aff0187d3e6fa118f25507c3ab4eef58465363d04c667e18e6c4d429b1f58904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fda90323828903c7634425fe17d0f42ff6de42862a60b5f791ad3d3a33ff6203"
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
