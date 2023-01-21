require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.50.tgz"
  sha256 "7b37b0b59321e6ee7545d246e05805403c93922b634ef425949945b838b344ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dde9c31bca7a13853adaba24f453c0e65777ed45dd04572098c59690eca8689"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dde9c31bca7a13853adaba24f453c0e65777ed45dd04572098c59690eca8689"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dde9c31bca7a13853adaba24f453c0e65777ed45dd04572098c59690eca8689"
    sha256 cellar: :any_skip_relocation, ventura:        "d63c3579a387188959613177f19189d88ec4e490e31c389105445bc702540df1"
    sha256 cellar: :any_skip_relocation, monterey:       "d63c3579a387188959613177f19189d88ec4e490e31c389105445bc702540df1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d63c3579a387188959613177f19189d88ec4e490e31c389105445bc702540df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dde9c31bca7a13853adaba24f453c0e65777ed45dd04572098c59690eca8689"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
