require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.22.1.tgz"
  sha256 "8a750852b6d6ac335c4c332201a85be0d76ed1ad160e74db569e714ed2a51191"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "766ed51cfdbc336a6aea2801ffa92d655b2eceb07288d879fa6c23d655c5bbd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "766ed51cfdbc336a6aea2801ffa92d655b2eceb07288d879fa6c23d655c5bbd6"
    sha256 cellar: :any_skip_relocation, monterey:       "e310a63107a92fab427feb85f6df7e01c0e2707b677bb2ff4c83c29103a10bef"
    sha256 cellar: :any_skip_relocation, big_sur:        "e310a63107a92fab427feb85f6df7e01c0e2707b677bb2ff4c83c29103a10bef"
    sha256 cellar: :any_skip_relocation, catalina:       "e310a63107a92fab427feb85f6df7e01c0e2707b677bb2ff4c83c29103a10bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64287f94c27da94137d1f69cadd36678b32e125ab4e15547af731606b5aa2d7"
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
