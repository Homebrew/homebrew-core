require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.14.0.tgz"
  sha256 "c5cf4c4a0b0c4a9422493a3223f24394ccea0efc68cb046aecdb115ba6c14a48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a3fb800855fa4ee7890ab193f22d67c781acf40bf90de748a181faa8252a4ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a3fb800855fa4ee7890ab193f22d67c781acf40bf90de748a181faa8252a4ef"
    sha256 cellar: :any_skip_relocation, monterey:       "49f45c0d5912b7f5c430b1389c13c6ef021e53fbd2a63d12ce7932cb059806fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "49f45c0d5912b7f5c430b1389c13c6ef021e53fbd2a63d12ce7932cb059806fc"
    sha256 cellar: :any_skip_relocation, catalina:       "49f45c0d5912b7f5c430b1389c13c6ef021e53fbd2a63d12ce7932cb059806fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "057b22fe88e5e5b89ecb9f6a031dfd22d0f9a6aef96eb4f1a5bc333fd756315d"
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
