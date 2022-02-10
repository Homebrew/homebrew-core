require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.13.3.tgz"
  sha256 "78248bca4e9c871e5d8bb4e0482b9a141243fcdf3d268424f1b18e87ea1fb4f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9180d9aa371188c04b45a29f302ab2d44b45de006bfbdf4aff4faa8213501222"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9180d9aa371188c04b45a29f302ab2d44b45de006bfbdf4aff4faa8213501222"
    sha256 cellar: :any_skip_relocation, monterey:       "1fb7b42e697f00d2ac76893b3d2bbd0cfd117ddfdc6d76295b8c32936b4d255f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fb7b42e697f00d2ac76893b3d2bbd0cfd117ddfdc6d76295b8c32936b4d255f"
    sha256 cellar: :any_skip_relocation, catalina:       "1fb7b42e697f00d2ac76893b3d2bbd0cfd117ddfdc6d76295b8c32936b4d255f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d3f85c79e840566057e3c3812546bb2d4cc9292363aada5a82dde88b60cfd49"
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
