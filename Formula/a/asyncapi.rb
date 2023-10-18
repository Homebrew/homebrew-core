require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.58.10.tgz"
  sha256 "125ea6628a14c59e075ac952f717200d463126a5a722becbada44648c75ddd00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d8bc9cf68a5946d38e02e8ce45c0c300ad8f434c23b9fa64def811245b608fc"
    sha256 cellar: :any,                 arm64_ventura:  "5d8bc9cf68a5946d38e02e8ce45c0c300ad8f434c23b9fa64def811245b608fc"
    sha256 cellar: :any,                 arm64_monterey: "5d8bc9cf68a5946d38e02e8ce45c0c300ad8f434c23b9fa64def811245b608fc"
    sha256 cellar: :any,                 sonoma:         "073e8bb4fad12f6525414bea1e1fbc6e6e6339819a001844026206a5c37802c8"
    sha256 cellar: :any,                 ventura:        "073e8bb4fad12f6525414bea1e1fbc6e6e6339819a001844026206a5c37802c8"
    sha256 cellar: :any,                 monterey:       "073e8bb4fad12f6525414bea1e1fbc6e6e6339819a001844026206a5c37802c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "156de95bcbc9be697e187cee8d50d1c86cc71b43525c579f618fec388e3ecaf8"
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
