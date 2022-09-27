require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.24.0.tgz"
  sha256 "9a30477384b2c0c83e6a7cef0a569dffa257c3a500e60859176cde5f9bdecae9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcbc05e757f1a675c21c0250f5e97ed34f5cb80fa645074beee58e9fdd5b9bb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcbc05e757f1a675c21c0250f5e97ed34f5cb80fa645074beee58e9fdd5b9bb1"
    sha256 cellar: :any_skip_relocation, monterey:       "f7650011bd4eb79ec7468de7e7956170e66a3f241e87037bb214f6a190eeac93"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7650011bd4eb79ec7468de7e7956170e66a3f241e87037bb214f6a190eeac93"
    sha256 cellar: :any_skip_relocation, catalina:       "f7650011bd4eb79ec7468de7e7956170e66a3f241e87037bb214f6a190eeac93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3498ebf8e0f52cd412a0fa9cc352e335733d174d948c154b8c9de601bc72570"
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
