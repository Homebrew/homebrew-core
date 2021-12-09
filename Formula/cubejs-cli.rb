require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.64.tgz"
  sha256 "83a2fe708f535ed093b2cb34f09eb9259f6f6d15e59ca1760db9faca5bb5179c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03e8eb1533747143d6679fb6385e8f9ad1b063ca0b1988384039859c68d19223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03e8eb1533747143d6679fb6385e8f9ad1b063ca0b1988384039859c68d19223"
    sha256 cellar: :any_skip_relocation, monterey:       "7ed34206a5443b8a444718f054a3e6e724a7378785b317820b879cde7e44009a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ed34206a5443b8a444718f054a3e6e724a7378785b317820b879cde7e44009a"
    sha256 cellar: :any_skip_relocation, catalina:       "7ed34206a5443b8a444718f054a3e6e724a7378785b317820b879cde7e44009a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e8eb1533747143d6679fb6385e8f9ad1b063ca0b1988384039859c68d19223"
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
