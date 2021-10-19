require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.45.tgz"
  sha256 "1e6dbc6bcb73d1664d420806524ae8f189c1234d15c6aa2e0f8a0fcd69828090"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "645ba1b2ac61751b71c8e1be7a7c9c4dfb15c357838f170547d81d4c1b7b3741"
    sha256 cellar: :any_skip_relocation, big_sur:       "d636b5282d1f5fa04449748d1600be92831d83afc4a04ee5ae04c2836be53554"
    sha256 cellar: :any_skip_relocation, catalina:      "d636b5282d1f5fa04449748d1600be92831d83afc4a04ee5ae04c2836be53554"
    sha256 cellar: :any_skip_relocation, mojave:        "d636b5282d1f5fa04449748d1600be92831d83afc4a04ee5ae04c2836be53554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "645ba1b2ac61751b71c8e1be7a7c9c4dfb15c357838f170547d81d4c1b7b3741"
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
