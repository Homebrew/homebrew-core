require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.26.1.tgz"
  sha256 "74eb1a0054cbc5bc282b71c4be0ed87fc670e657fe91ab51ef2f5fc74a20ae82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "604a08dfde3562ccdbb26aa68aa9055353e5bedde5a30e19827ab569217a4239"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "604a08dfde3562ccdbb26aa68aa9055353e5bedde5a30e19827ab569217a4239"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "604a08dfde3562ccdbb26aa68aa9055353e5bedde5a30e19827ab569217a4239"
    sha256 cellar: :any_skip_relocation, monterey:       "1e1bca1aefdd2c8c1ecdab60732a84dafb29b9a79e93f82c93448caa4b3722ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e1bca1aefdd2c8c1ecdab60732a84dafb29b9a79e93f82c93448caa4b3722ec"
    sha256 cellar: :any_skip_relocation, catalina:       "1e1bca1aefdd2c8c1ecdab60732a84dafb29b9a79e93f82c93448caa4b3722ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae2a8aa81bde8139a19c2d4719f827dd6cbfa0719391163064a7a7ed5d567e6f"
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
