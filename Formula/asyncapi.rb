require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.38.0.tgz"
  sha256 "4fdf658df8c1d9284919be739dfd93bd4b6a56831a6d4c8416a2c26d7a3f38b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "64bb3a9eaae2aa88b540412cfc4b8f6775061f42ec1440a8129c784d1d41edfa"
    sha256 cellar: :any,                 arm64_monterey: "64bb3a9eaae2aa88b540412cfc4b8f6775061f42ec1440a8129c784d1d41edfa"
    sha256 cellar: :any,                 arm64_big_sur:  "64bb3a9eaae2aa88b540412cfc4b8f6775061f42ec1440a8129c784d1d41edfa"
    sha256 cellar: :any,                 ventura:        "dba179dc83d91c82acc56a65e3729a7624139e81d4d9ee58feb4a6f2ae13fa1e"
    sha256 cellar: :any,                 monterey:       "dba179dc83d91c82acc56a65e3729a7624139e81d4d9ee58feb4a6f2ae13fa1e"
    sha256 cellar: :any,                 big_sur:        "dba179dc83d91c82acc56a65e3729a7624139e81d4d9ee58feb4a6f2ae13fa1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "319cb52716aa2f8acfbbb07ccdc0a3eb0bf218bde28c77fa29f309483924cd87"
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
