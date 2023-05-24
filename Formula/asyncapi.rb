require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.41.0.tgz"
  sha256 "c182eabb36200919ad0e91c089fd8b5af0f00cfd49bb10609cd764e2474e273b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d74a4a91f25f228f93496c0cb7c019c3cde5eae080d54dd72d650d75c4e4133d"
    sha256 cellar: :any,                 arm64_monterey: "d74a4a91f25f228f93496c0cb7c019c3cde5eae080d54dd72d650d75c4e4133d"
    sha256 cellar: :any,                 arm64_big_sur:  "d74a4a91f25f228f93496c0cb7c019c3cde5eae080d54dd72d650d75c4e4133d"
    sha256 cellar: :any,                 ventura:        "08458a3adde4c0dc02f67e775ad63147a5e7fe8bb2225f96d4ee14eb827c9901"
    sha256 cellar: :any,                 monterey:       "08458a3adde4c0dc02f67e775ad63147a5e7fe8bb2225f96d4ee14eb827c9901"
    sha256 cellar: :any,                 big_sur:        "08458a3adde4c0dc02f67e775ad63147a5e7fe8bb2225f96d4ee14eb827c9901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71f06d95b45aa16946c8e781481231d63f4f51e49c4aab39f0db8808dbfc5f8c"
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
