require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.19.1.tgz"
  sha256 "c261968c6d86a07cb56e3d633031c55428d37dde1cd7087a345d46ea595f89e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5e8c2a95ff2c0c1d4705d485e8cc0b90e44d5889f1ba49920f27dab479f4e38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5e8c2a95ff2c0c1d4705d485e8cc0b90e44d5889f1ba49920f27dab479f4e38"
    sha256 cellar: :any_skip_relocation, monterey:       "9effe6c80ef7d62d743666ebb4c6545d786e29f315440b15c46785d950a239ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "9effe6c80ef7d62d743666ebb4c6545d786e29f315440b15c46785d950a239ea"
    sha256 cellar: :any_skip_relocation, catalina:       "9effe6c80ef7d62d743666ebb4c6545d786e29f315440b15c46785d950a239ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce852e57a2ffce4472b96bf11911538e4fc6dc0fa3e2520b2b70b86ee1e048fd"
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
