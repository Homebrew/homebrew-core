require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.0.tgz"
  sha256 "055378d113db9d312148580b818900ce9e57288b56d5e0addef8e5fd67d95065"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b86c45b6e5cbc7af75c22e5390b8f4188a15f845215eb6be451c6d44f568d0c3"
    sha256 cellar: :any,                 arm64_ventura:  "b86c45b6e5cbc7af75c22e5390b8f4188a15f845215eb6be451c6d44f568d0c3"
    sha256 cellar: :any,                 arm64_monterey: "b86c45b6e5cbc7af75c22e5390b8f4188a15f845215eb6be451c6d44f568d0c3"
    sha256 cellar: :any,                 sonoma:         "d499c0294af54f8b0e0e8905e191a085a899c16676e1917d2151ba88ebec5d97"
    sha256 cellar: :any,                 ventura:        "d499c0294af54f8b0e0e8905e191a085a899c16676e1917d2151ba88ebec5d97"
    sha256 cellar: :any,                 monterey:       "d499c0294af54f8b0e0e8905e191a085a899c16676e1917d2151ba88ebec5d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6afe86d31e93e3746c268d5b9a9c9cfb9f39eb929f3fc01551ef554bbfaa204"
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
