require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.12.tgz"
  sha256 "ed993cf1fd32ac0ec60ff864fff0a275b6294daa603bcfb94651c99a0bd9e20a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b50acaa599ff911a375f63966c5a09527e67e3a5b86189fc4c716b0368b4bafa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b50acaa599ff911a375f63966c5a09527e67e3a5b86189fc4c716b0368b4bafa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b50acaa599ff911a375f63966c5a09527e67e3a5b86189fc4c716b0368b4bafa"
    sha256 cellar: :any_skip_relocation, monterey:       "d7020f1b772659ab5790d97a8a4dea7376a4978fb9752ac37977b29c377de9cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7020f1b772659ab5790d97a8a4dea7376a4978fb9752ac37977b29c377de9cf"
    sha256 cellar: :any_skip_relocation, catalina:       "d7020f1b772659ab5790d97a8a4dea7376a4978fb9752ac37977b29c377de9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b50acaa599ff911a375f63966c5a09527e67e3a5b86189fc4c716b0368b4bafa"
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
