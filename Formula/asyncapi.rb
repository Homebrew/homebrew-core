require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.15.0.tgz"
  sha256 "192d178592a0e2944ffb5795b43b8331b89412e5583aeef43ac32accdbe911a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6c1b8cd5eec9b746fde74c62c8da9994f3ed6c1f8987acc7808eb4516201496"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6c1b8cd5eec9b746fde74c62c8da9994f3ed6c1f8987acc7808eb4516201496"
    sha256 cellar: :any_skip_relocation, monterey:       "4fd7fb0530211f96dcd12d5361a26273b82809f517691e6affd957d631dbfced"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fd7fb0530211f96dcd12d5361a26273b82809f517691e6affd957d631dbfced"
    sha256 cellar: :any_skip_relocation, catalina:       "4fd7fb0530211f96dcd12d5361a26273b82809f517691e6affd957d631dbfced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38130e6e318632d2aafd0621d199af4b4cac2c067d3c596548d992ab779a0726"
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
