require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.5.35.tgz"
  sha256 "b62c4b67ed38e7d0bca79290c57c16a0787d76796f2a08276c545ea2ef02b710"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "79c006b3e1080c0c3ab656ddbee763c396cf51c8bbe92f501c2fd27b6f582746"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a18ff7059abaea9c2e2891ea068cc3d383fbf1c10364497155448fe1c495f00"
    sha256 cellar: :any_skip_relocation, catalina:      "bd78afc86bebf0552969959876d84f27a8517932ad01d0446402d5cba66688da"
    sha256 cellar: :any_skip_relocation, mojave:        "b6bd46afc3a16e6d04679c0ded378b582efe8168f367f2bd955e499f619d468d"
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
