require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.58.5.tgz"
  sha256 "ddd6896f9b21619043a250ec6b6c838b483aaf770bad73d1402f13835e126de4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6e223768580719303d1cf92b4c83b1bc354c1e35ac1b5b6f2c187e1e17c334d2"
    sha256 cellar: :any,                 arm64_ventura:  "6e223768580719303d1cf92b4c83b1bc354c1e35ac1b5b6f2c187e1e17c334d2"
    sha256 cellar: :any,                 arm64_monterey: "6e223768580719303d1cf92b4c83b1bc354c1e35ac1b5b6f2c187e1e17c334d2"
    sha256 cellar: :any,                 sonoma:         "d2fbaf30a5e092ab856b184dca892295db25ec5d353bfd305f686f2106136848"
    sha256 cellar: :any,                 ventura:        "d2fbaf30a5e092ab856b184dca892295db25ec5d353bfd305f686f2106136848"
    sha256 cellar: :any,                 monterey:       "d2fbaf30a5e092ab856b184dca892295db25ec5d353bfd305f686f2106136848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d5c94864c5b0340c455bb6d2498fbb69d4551e144c3fc7ba3d626f00e65520"
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
