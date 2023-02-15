require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.31.1.tgz"
  sha256 "bc6dd71e35246dfae85a2a9def7346ef1cfb1f4da3ffa0abff7f62727fa39bc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d336051532a2f109e158b97751ef1ea6d2bf115a5b956ff253cbfce8c495cc8b"
    sha256 cellar: :any,                 arm64_monterey: "d336051532a2f109e158b97751ef1ea6d2bf115a5b956ff253cbfce8c495cc8b"
    sha256 cellar: :any,                 arm64_big_sur:  "d336051532a2f109e158b97751ef1ea6d2bf115a5b956ff253cbfce8c495cc8b"
    sha256 cellar: :any,                 ventura:        "3b6b68b2af16976a312fa3fe384d78d29ad465e4d30e20fab0418ad8fbba2ed2"
    sha256 cellar: :any,                 monterey:       "3b6b68b2af16976a312fa3fe384d78d29ad465e4d30e20fab0418ad8fbba2ed2"
    sha256 cellar: :any,                 big_sur:        "3b6b68b2af16976a312fa3fe384d78d29ad465e4d30e20fab0418ad8fbba2ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd303daab20fb09a8f1abecf4e900ea7fca716474d9f9f9e9fe4896fdb1334ef"
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
