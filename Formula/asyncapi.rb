require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.48.0.tgz"
  sha256 "3263290bec7f290e58cd9350fcac89b22f645c65333715d24d076f34651e5758"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "80471f6cc772df6cce670fdb24a8ce6b8ea666a1be56edd9976401e669bf8849"
    sha256 cellar: :any,                 arm64_monterey: "80471f6cc772df6cce670fdb24a8ce6b8ea666a1be56edd9976401e669bf8849"
    sha256 cellar: :any,                 arm64_big_sur:  "b24473f5d0cd2dff60605c32643bcfb45ce6a3efbcd43ed31f7abd1a691afc26"
    sha256 cellar: :any,                 ventura:        "036243accb0dd4a0eacd80d261f14e2612aacd72d30d4a24e6c654cb97b19150"
    sha256 cellar: :any,                 monterey:       "036243accb0dd4a0eacd80d261f14e2612aacd72d30d4a24e6c654cb97b19150"
    sha256 cellar: :any,                 big_sur:        "036243accb0dd4a0eacd80d261f14e2612aacd72d30d4a24e6c654cb97b19150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a29dffe634eb1e3f0a3e1a783ea18227e68b73a2b6171d75451a82152d3e7652"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
