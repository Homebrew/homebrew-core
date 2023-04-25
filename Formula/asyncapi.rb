require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.39.3.tgz"
  sha256 "1cd285c7a9ea7cdffd567b8230f80a1b9518a84eb345ce7727bef2c3bacaf5ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "df3d8d92fb85703fc2f53b1a0c908eb748ca005572da0b7ad2dfc673832f41ec"
    sha256 cellar: :any,                 arm64_monterey: "df3d8d92fb85703fc2f53b1a0c908eb748ca005572da0b7ad2dfc673832f41ec"
    sha256 cellar: :any,                 arm64_big_sur:  "df3d8d92fb85703fc2f53b1a0c908eb748ca005572da0b7ad2dfc673832f41ec"
    sha256 cellar: :any,                 ventura:        "1365bad7c675dd10cc6ea16e9972782ec04726b04533b30e242df19b31cf9eaf"
    sha256 cellar: :any,                 monterey:       "1365bad7c675dd10cc6ea16e9972782ec04726b04533b30e242df19b31cf9eaf"
    sha256 cellar: :any,                 big_sur:        "1365bad7c675dd10cc6ea16e9972782ec04726b04533b30e242df19b31cf9eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ce53181fbb7cd877fb4a595d9edfc01606aa8432c0efc47e379e38c17b4cf9d"
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
