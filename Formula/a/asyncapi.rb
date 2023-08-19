require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.53.0.tgz"
  sha256 "74017efbe651d883353b4d77d8f5c16e40c7164e0af2d615a2b0cd131b1f509c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dafe3e46fbac4799c4b3a4e46de985d49b985ebcab5833c9279531c79cb15b49"
    sha256 cellar: :any,                 arm64_monterey: "dafe3e46fbac4799c4b3a4e46de985d49b985ebcab5833c9279531c79cb15b49"
    sha256 cellar: :any,                 arm64_big_sur:  "dafe3e46fbac4799c4b3a4e46de985d49b985ebcab5833c9279531c79cb15b49"
    sha256 cellar: :any,                 ventura:        "1ffc2079bfc6044cc5c05f875d6ef7e0e4420f24bf917ba05c00e85fc1ab9b74"
    sha256 cellar: :any,                 monterey:       "1ffc2079bfc6044cc5c05f875d6ef7e0e4420f24bf917ba05c00e85fc1ab9b74"
    sha256 cellar: :any,                 big_sur:        "1ffc2079bfc6044cc5c05f875d6ef7e0e4420f24bf917ba05c00e85fc1ab9b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b8f69b9554429c2737fa4270ab566aab310388c4d1eed87bb19a3d20cdea7f4"
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
