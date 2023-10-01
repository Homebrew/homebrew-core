require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.58.0.tgz"
  sha256 "47198bf3e013cabb39e2c3b1e4693ea5c5d701948b90cde2ef896ffb6cf8b207"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8be0d7523462b969a74215e1f6c2c304ac0d30e7242282940ff20fbd23c74cd0"
    sha256 cellar: :any,                 arm64_monterey: "8be0d7523462b969a74215e1f6c2c304ac0d30e7242282940ff20fbd23c74cd0"
    sha256 cellar: :any,                 arm64_big_sur:  "8be0d7523462b969a74215e1f6c2c304ac0d30e7242282940ff20fbd23c74cd0"
    sha256 cellar: :any,                 ventura:        "0f56ea915e2b26d4dd231129903fbd80e846403394ee8f12be807949a42d766c"
    sha256 cellar: :any,                 monterey:       "a0ced2e5e0818937108af506bf02d78602d202f9347de60573515fa4795f6bb0"
    sha256 cellar: :any,                 big_sur:        "a0ced2e5e0818937108af506bf02d78602d202f9347de60573515fa4795f6bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "accf7f14edffd9ef7697b97c23cd3999f6ef3973c665080914fb11e7f826c584"
  end

  depends_on "node"

  def install
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
