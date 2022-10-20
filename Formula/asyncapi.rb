require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.25.3.tgz"
  sha256 "9f4766babfb0f6f2719fa404e9aeeacc7449500ccd7df22d24cd8977a9acb9dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "180e905314e7d0ea44c2a9313cbf7516f95a427e7fcb68e521b0227a1f429e99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "180e905314e7d0ea44c2a9313cbf7516f95a427e7fcb68e521b0227a1f429e99"
    sha256 cellar: :any_skip_relocation, monterey:       "4da08fcb8646972c56fc985afbd8474225c195e2301509f8f6aa7bd51f135016"
    sha256 cellar: :any_skip_relocation, big_sur:        "4da08fcb8646972c56fc985afbd8474225c195e2301509f8f6aa7bd51f135016"
    sha256 cellar: :any_skip_relocation, catalina:       "4da08fcb8646972c56fc985afbd8474225c195e2301509f8f6aa7bd51f135016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e17e73390d34d4fbf9e26bcd511a7fabfa0710f23820ebaaa80de1b97342055"
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
