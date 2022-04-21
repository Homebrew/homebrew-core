require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.18.2.tgz"
  sha256 "37972da81bd62ab0d6f5944a00b0fc0e7208631506143719e7eaf45465488fd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dc64155449ca1ee6a94ea22aae78bba65c5c4aea11911017d8909721625f378"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dc64155449ca1ee6a94ea22aae78bba65c5c4aea11911017d8909721625f378"
    sha256 cellar: :any_skip_relocation, monterey:       "8fe1e512518e794db4b94bfce4796127b845ac98e07bd31201cfa207d06f21be"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fe1e512518e794db4b94bfce4796127b845ac98e07bd31201cfa207d06f21be"
    sha256 cellar: :any_skip_relocation, catalina:       "8fe1e512518e794db4b94bfce4796127b845ac98e07bd31201cfa207d06f21be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "334f69b3513c3af7c0f11198948aa92fbc9611e2d130b43538eeb99a7d097b8e"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
