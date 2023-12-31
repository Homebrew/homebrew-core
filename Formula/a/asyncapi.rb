require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.29.tgz"
  sha256 "4008ae08e928b77f392a4ba83493df6f5da69281b92afd7cfa30adfbfac3dffa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9c590d47fea4e6182f6520a4aa4d037d9267468d946197fa2092161aeeba7762"
    sha256 cellar: :any,                 arm64_ventura:  "9c590d47fea4e6182f6520a4aa4d037d9267468d946197fa2092161aeeba7762"
    sha256 cellar: :any,                 arm64_monterey: "9c590d47fea4e6182f6520a4aa4d037d9267468d946197fa2092161aeeba7762"
    sha256 cellar: :any,                 sonoma:         "19fca66f0cf5bfdee33b31c11136899dadf0c6639baeec34eda87d198175e7b9"
    sha256 cellar: :any,                 ventura:        "19fca66f0cf5bfdee33b31c11136899dadf0c6639baeec34eda87d198175e7b9"
    sha256 cellar: :any,                 monterey:       "19fca66f0cf5bfdee33b31c11136899dadf0c6639baeec34eda87d198175e7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8172eab91c929d884d7040544a4fa2f74dcd997dcb7fc14473b657df529a6749"
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
