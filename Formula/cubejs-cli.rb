require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.19.51.tgz"
  sha256 "2022d2f7614e0354e4294252c17dd93dc938251cc30a309c16e1741164aa9f7d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "28956e5b0af37c95adea0dea763486bd616824bc279a4dc285c0b9eedea29c60" => :catalina
    sha256 "024a14d3785b779ddef050f5f1fa8b1deddce9717647957f89d62c49042022aa" => :mojave
    sha256 "bf23e7ee8d73238b3d6c2edd3a7cfecbe3e5b32426748debf12f36741269edaf" => :high_sierra
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
