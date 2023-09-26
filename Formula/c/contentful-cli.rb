require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.20.tgz"
  sha256 "4eb06552cb4046702feedd8c369e2d87538277d0fbe1a273d37cc6c3923304ec"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7642d5a162cdfb71ef549c817b50e46bbe39a008b2951e4a844c2e957fea7eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7642d5a162cdfb71ef549c817b50e46bbe39a008b2951e4a844c2e957fea7eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7642d5a162cdfb71ef549c817b50e46bbe39a008b2951e4a844c2e957fea7eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd7a7d0df9cda3cba83c5dd0b4944eade023d227d0488c5513b6f7183d97e1a3"
    sha256 cellar: :any_skip_relocation, ventura:        "dd7a7d0df9cda3cba83c5dd0b4944eade023d227d0488c5513b6f7183d97e1a3"
    sha256 cellar: :any_skip_relocation, monterey:       "dd7a7d0df9cda3cba83c5dd0b4944eade023d227d0488c5513b6f7183d97e1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7642d5a162cdfb71ef549c817b50e46bbe39a008b2951e4a844c2e957fea7eb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
