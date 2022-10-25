require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.25.4.tgz"
  sha256 "2e70a3929fdce6d036b7234cdadd61547a586090091fd96064f2c7372774a110"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "334d4583222a434122f416d84d28929ba542969fb7d55cf92acd8a48ea5048dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "334d4583222a434122f416d84d28929ba542969fb7d55cf92acd8a48ea5048dc"
    sha256 cellar: :any_skip_relocation, monterey:       "fbad939d73d9bae09b0c0449acf38c4c9abfc1f8bf9f720d03209b87fdb51827"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbad939d73d9bae09b0c0449acf38c4c9abfc1f8bf9f720d03209b87fdb51827"
    sha256 cellar: :any_skip_relocation, catalina:       "fbad939d73d9bae09b0c0449acf38c4c9abfc1f8bf9f720d03209b87fdb51827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d79bb794c617c8ab1476a962ae4b4803b579d86e472367d76fe7eee89eebf97a"
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
