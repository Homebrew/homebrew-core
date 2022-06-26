require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.19.4.tgz"
  sha256 "b8e3165edc57d3b5b0fc232f48a4825878d5239b915888a3e2fd3400b4ffba32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e79cc39688d54b7ccc5a1d98dd7b4a647256723acc69a1f8acb66d408dc33aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e79cc39688d54b7ccc5a1d98dd7b4a647256723acc69a1f8acb66d408dc33aa"
    sha256 cellar: :any_skip_relocation, monterey:       "4d6294523554dc8111bdb7d94c4ab8694d3f8385dae0421bb74ca447682ff9a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d6294523554dc8111bdb7d94c4ab8694d3f8385dae0421bb74ca447682ff9a9"
    sha256 cellar: :any_skip_relocation, catalina:       "4d6294523554dc8111bdb7d94c4ab8694d3f8385dae0421bb74ca447682ff9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53a29b8c083bbfb9f1b02e9a1595053494039b1b3d548e496f2d77821ba0e6f8"
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
