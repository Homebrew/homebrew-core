require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.54.5.tgz"
  sha256 "d8cced0ef1235d5f19bcd6f7f8990d7246bda71689e64bf486b5d79b050cd3d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6685abbbf7e776b29ba43cf25050c83fc5e25a4fb71178ca0d85554aadf3b935"
    sha256 cellar: :any,                 arm64_monterey: "6685abbbf7e776b29ba43cf25050c83fc5e25a4fb71178ca0d85554aadf3b935"
    sha256 cellar: :any,                 arm64_big_sur:  "6685abbbf7e776b29ba43cf25050c83fc5e25a4fb71178ca0d85554aadf3b935"
    sha256 cellar: :any,                 ventura:        "2bf3d2f4cddb89e0b713e9dfd23b9e605942723f3d9acc3eedf55382ade2822b"
    sha256 cellar: :any,                 monterey:       "2bf3d2f4cddb89e0b713e9dfd23b9e605942723f3d9acc3eedf55382ade2822b"
    sha256 cellar: :any,                 big_sur:        "2bf3d2f4cddb89e0b713e9dfd23b9e605942723f3d9acc3eedf55382ade2822b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc9c20084689f3319e080c6507e7335fb75ac391099487eff67fbd1f6af42f27"
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
