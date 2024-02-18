require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.5.7.tgz"
  sha256 "13654fe3a54ae43e4bd05fc23151c8daf7a9a41784b5e365f1673e13c7372f2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1172a006c9ad2cd2c443f770da61ac0fb0185c56a2656567b273343329c15809"
    sha256 cellar: :any,                 arm64_ventura:  "1172a006c9ad2cd2c443f770da61ac0fb0185c56a2656567b273343329c15809"
    sha256 cellar: :any,                 arm64_monterey: "1172a006c9ad2cd2c443f770da61ac0fb0185c56a2656567b273343329c15809"
    sha256 cellar: :any,                 sonoma:         "d3356fa65f60efa01d807ffac07a601bcaa3071b455b06ec0cdbc82820ab6b26"
    sha256 cellar: :any,                 ventura:        "d3356fa65f60efa01d807ffac07a601bcaa3071b455b06ec0cdbc82820ab6b26"
    sha256 cellar: :any,                 monterey:       "d3356fa65f60efa01d807ffac07a601bcaa3071b455b06ec0cdbc82820ab6b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4ffa4d6cf051c797b1aa3ce25b3fdf5c3c63f09a2fe1195c20d038fdf7407d7"
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
