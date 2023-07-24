require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.51.1.tgz"
  sha256 "870caed7e9e209bfe9dda170c15ec1b00aba20de0f14665771d17645447d6c2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "322cdfbd776ad36ee0e9b8aaf35c10564a4acb39ab6486bf898b4c86c7c60671"
    sha256 cellar: :any,                 arm64_monterey: "322cdfbd776ad36ee0e9b8aaf35c10564a4acb39ab6486bf898b4c86c7c60671"
    sha256 cellar: :any,                 arm64_big_sur:  "322cdfbd776ad36ee0e9b8aaf35c10564a4acb39ab6486bf898b4c86c7c60671"
    sha256 cellar: :any,                 ventura:        "087f63e3265d9bf60864c3072cbde10b889e8eaf8f91df15fab6d2c4b11c243a"
    sha256 cellar: :any,                 monterey:       "087f63e3265d9bf60864c3072cbde10b889e8eaf8f91df15fab6d2c4b11c243a"
    sha256 cellar: :any,                 big_sur:        "087f63e3265d9bf60864c3072cbde10b889e8eaf8f91df15fab6d2c4b11c243a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5bf76435a57825bef6fc25a104831b3a0d3add86f06ce134d714b27b4ce0ca2"
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
