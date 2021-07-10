require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.49.tgz"
  sha256 "414d8f4459e86f843441e13aafe8a0759cce953fe38d90979e5bb432989ac636"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46afa0852d343a53973dc912b597dc2f1ae5a48f5fe1a5b4adcb4f40fad5b86a"
    sha256 cellar: :any_skip_relocation, big_sur:       "6226565c18bc3fe6ea61476fb5fa3697f44fcda304a49e0ed785d0226509791a"
    sha256 cellar: :any_skip_relocation, catalina:      "6226565c18bc3fe6ea61476fb5fa3697f44fcda304a49e0ed785d0226509791a"
    sha256 cellar: :any_skip_relocation, mojave:        "6226565c18bc3fe6ea61476fb5fa3697f44fcda304a49e0ed785d0226509791a"
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
