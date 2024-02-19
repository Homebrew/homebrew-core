require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.5.10.tgz"
  sha256 "3e472e0ba97a59cb8549231d06199e4abd0c834670126da1572d83c0ab2a74e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5e5f68a0fc178d64fd6adb5c7256a594c6c3720795465e1cc55031576e40af2b"
    sha256 cellar: :any,                 arm64_ventura:  "5e5f68a0fc178d64fd6adb5c7256a594c6c3720795465e1cc55031576e40af2b"
    sha256 cellar: :any,                 arm64_monterey: "5e5f68a0fc178d64fd6adb5c7256a594c6c3720795465e1cc55031576e40af2b"
    sha256 cellar: :any,                 sonoma:         "78d5572b06d213363756d538d554bf0cb3ea913528d434190e8bd08a77d9603d"
    sha256 cellar: :any,                 ventura:        "78d5572b06d213363756d538d554bf0cb3ea913528d434190e8bd08a77d9603d"
    sha256 cellar: :any,                 monterey:       "78d5572b06d213363756d538d554bf0cb3ea913528d434190e8bd08a77d9603d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e0e25e59ae6c8216e75ab6f92612dfb3c41863abba1abae1588b225b7c38ddb"
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
