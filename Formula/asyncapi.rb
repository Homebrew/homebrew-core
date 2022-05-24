require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.19.3.tgz"
  sha256 "1109cd831c888a9578ce70211add2836e2752ccef71fda48611dcad771f1d5e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7758a4937d4b16cc6f9674f77fb476f0ecc2efca5568382c7096eb77d07f41c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7758a4937d4b16cc6f9674f77fb476f0ecc2efca5568382c7096eb77d07f41c"
    sha256 cellar: :any_skip_relocation, monterey:       "6ee4e2763e13358a7ec6f1a71fcfdfc757a2b65e2a1c89f158681e938867eee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ee4e2763e13358a7ec6f1a71fcfdfc757a2b65e2a1c89f158681e938867eee2"
    sha256 cellar: :any_skip_relocation, catalina:       "6ee4e2763e13358a7ec6f1a71fcfdfc757a2b65e2a1c89f158681e938867eee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf4d62c19fd525aa7f84d11afa06c604b652535798360018fb67ffa50621cdae"
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
