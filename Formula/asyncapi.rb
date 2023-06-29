require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.50.0.tgz"
  sha256 "39ff6c68cbfbca130a5025e220ca64d928c2efcc278d9686a9989f416e0679e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d80e70e868d198f0052a61dce6db0179b19de4d80bc491834d39d08c7136447a"
    sha256 cellar: :any,                 arm64_monterey: "d80e70e868d198f0052a61dce6db0179b19de4d80bc491834d39d08c7136447a"
    sha256 cellar: :any,                 arm64_big_sur:  "d80e70e868d198f0052a61dce6db0179b19de4d80bc491834d39d08c7136447a"
    sha256 cellar: :any,                 ventura:        "8e7a50a5bc9c804c4a027d6f114d38b4d4f70286e388dd2010a5a0408d396fec"
    sha256 cellar: :any,                 monterey:       "8e7a50a5bc9c804c4a027d6f114d38b4d4f70286e388dd2010a5a0408d396fec"
    sha256 cellar: :any,                 big_sur:        "8e7a50a5bc9c804c4a027d6f114d38b4d4f70286e388dd2010a5a0408d396fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc74dfcedf85145115efc5d35849dc574fee8f0b78b515a7be2709ca42359f1"
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
