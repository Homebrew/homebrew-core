require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.13.0.tgz"
  sha256 "0682818d414dc7994a8433f29a1e4b151e0fa81e54956a3a19e2431fb88c54bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d23145b6224a800316c04cd458607a1456b2560170bde5a20a0cea7963b89cb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d23145b6224a800316c04cd458607a1456b2560170bde5a20a0cea7963b89cb3"
    sha256 cellar: :any_skip_relocation, monterey:       "4c79214e9b4bcb44bb070e967da7442f203a1871b6718bcc1242166fec534cf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c79214e9b4bcb44bb070e967da7442f203a1871b6718bcc1242166fec534cf1"
    sha256 cellar: :any_skip_relocation, catalina:       "4c79214e9b4bcb44bb070e967da7442f203a1871b6718bcc1242166fec534cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58badae75a812bc0e8771251abd11991b6e7a46ccd4e23cbec9be829e7147e3b"
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
