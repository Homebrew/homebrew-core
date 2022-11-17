require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.26.0.tgz"
  sha256 "1feec1d8a53f55c5a3e9add5bcacdf8105704bb08255460a00f6ec8913075d7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d97a3206c005cfe1707ce33d495fe383658731a7c6357a19ad60ae210ef9f78a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d97a3206c005cfe1707ce33d495fe383658731a7c6357a19ad60ae210ef9f78a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d97a3206c005cfe1707ce33d495fe383658731a7c6357a19ad60ae210ef9f78a"
    sha256 cellar: :any_skip_relocation, monterey:       "3a853e2e1c71f751ee73ace1cb01b7a1b43c941f6a84d3e21a9a6475ebc31155"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a853e2e1c71f751ee73ace1cb01b7a1b43c941f6a84d3e21a9a6475ebc31155"
    sha256 cellar: :any_skip_relocation, catalina:       "3a853e2e1c71f751ee73ace1cb01b7a1b43c941f6a84d3e21a9a6475ebc31155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae0066dd9fbdfec723dc55857ce2bd16018ba2c38fb85a1f2c502c8b47ed4d57"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
