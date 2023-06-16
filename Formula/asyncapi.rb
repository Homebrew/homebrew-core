require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.48.5.tgz"
  sha256 "84b0131e02ba7ac4944d350c3a3460e9ed91fb07e60ea2b2d66db9a030f3117f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "55b3e964f612119b35f11fcd86cd31568ee3c5df3da33b4a1a8802e5acce29ec"
    sha256 cellar: :any,                 arm64_monterey: "55b3e964f612119b35f11fcd86cd31568ee3c5df3da33b4a1a8802e5acce29ec"
    sha256 cellar: :any,                 arm64_big_sur:  "55b3e964f612119b35f11fcd86cd31568ee3c5df3da33b4a1a8802e5acce29ec"
    sha256 cellar: :any,                 ventura:        "ac82956c7bb0152e58870984cc0ab594d66c71148b3ab260ad74868ad11f3a90"
    sha256 cellar: :any,                 monterey:       "ac82956c7bb0152e58870984cc0ab594d66c71148b3ab260ad74868ad11f3a90"
    sha256 cellar: :any,                 big_sur:        "ac82956c7bb0152e58870984cc0ab594d66c71148b3ab260ad74868ad11f3a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3d9345adee9bbf0c7326c603e7d0e5791c060c16d527ef0d771c1ebacf103d"
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
