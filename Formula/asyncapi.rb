require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.47.8.tgz"
  sha256 "a72876ef9efa54858cf55b67360aa868de8c75f3830f0da150367a1bea930246"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2b2d005bb0a60f3c307a5256cd8211c4b1fb5a05f94c6f357064a11debded3e4"
    sha256 cellar: :any,                 arm64_monterey: "2b2d005bb0a60f3c307a5256cd8211c4b1fb5a05f94c6f357064a11debded3e4"
    sha256 cellar: :any,                 arm64_big_sur:  "2b2d005bb0a60f3c307a5256cd8211c4b1fb5a05f94c6f357064a11debded3e4"
    sha256 cellar: :any,                 ventura:        "b21f999223b3908ab5658363a278b8485602fb958e6cab5d74efd93574ae1772"
    sha256 cellar: :any,                 monterey:       "b21f999223b3908ab5658363a278b8485602fb958e6cab5d74efd93574ae1772"
    sha256 cellar: :any,                 big_sur:        "b21f999223b3908ab5658363a278b8485602fb958e6cab5d74efd93574ae1772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8b2f14a618b9946c69ee61eeb1be2ce32f73bb0193458eab6f021c5e79f52b6"
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
