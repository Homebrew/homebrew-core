require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.5.tgz"
  sha256 "e90711835326cf958cf693624ced33afd9f6c665be08cb3fd3addee4472732c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f958031eefc73167fea4a86ffa68b3416f8ccd5d52a17f2993457e188505c2cd"
    sha256 cellar: :any,                 arm64_ventura:  "f958031eefc73167fea4a86ffa68b3416f8ccd5d52a17f2993457e188505c2cd"
    sha256 cellar: :any,                 arm64_monterey: "f958031eefc73167fea4a86ffa68b3416f8ccd5d52a17f2993457e188505c2cd"
    sha256 cellar: :any,                 sonoma:         "2ce1bb1e51d3fbeb4be769c5be3c1082ee3db804bbc22fd10dbc55755c2f83c2"
    sha256 cellar: :any,                 ventura:        "0f21ab5cd8341dbb47a3440385ae6063b78cd01ec19ad57ef40dcded3f6aadf6"
    sha256 cellar: :any,                 monterey:       "2ce1bb1e51d3fbeb4be769c5be3c1082ee3db804bbc22fd10dbc55755c2f83c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945ab9b3e552603d1fa47d95044895628c8e01067cb7593e2cee2a74c5283db8"
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
