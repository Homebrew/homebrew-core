require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.50.tgz"
  sha256 "a55820d30a9e9d4b78159903462bd9d65944461f31fe3f7beedb562de70168ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ffd158184b486a9a5a12a2d40324d848d72e6556851db287a4759c5187ce6cc8"
    sha256 cellar: :any_skip_relocation, big_sur:       "a192c3597d34ceab5bf0abc1659a045cf924b49dc8fac780956be84e4f080832"
    sha256 cellar: :any_skip_relocation, catalina:      "a192c3597d34ceab5bf0abc1659a045cf924b49dc8fac780956be84e4f080832"
    sha256 cellar: :any_skip_relocation, mojave:        "a192c3597d34ceab5bf0abc1659a045cf924b49dc8fac780956be84e4f080832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b94cc536bdb4f9df4a74a6ddfeb5b82d0179a77b4be7f893993366b30e3cddb"
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
