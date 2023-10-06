require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.27.tgz"
  sha256 "0b7562e9f887bfea5ca5ef8a056c436aa4b4e6ba50a4e4f73d0cdd01dc97e00e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc94952240e5ed9483d81ea7225210b56b3efc88b2d88fb8861bcf7b1c612054"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc94952240e5ed9483d81ea7225210b56b3efc88b2d88fb8861bcf7b1c612054"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc94952240e5ed9483d81ea7225210b56b3efc88b2d88fb8861bcf7b1c612054"
    sha256 cellar: :any_skip_relocation, sonoma:         "e17a151ccdc90d47a3eec07e56eb25694903cf2ee85506fa8b662299545d2adb"
    sha256 cellar: :any_skip_relocation, ventura:        "e17a151ccdc90d47a3eec07e56eb25694903cf2ee85506fa8b662299545d2adb"
    sha256 cellar: :any_skip_relocation, monterey:       "e17a151ccdc90d47a3eec07e56eb25694903cf2ee85506fa8b662299545d2adb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc94952240e5ed9483d81ea7225210b56b3efc88b2d88fb8861bcf7b1c612054"
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
