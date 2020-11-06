require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.23.8.tgz"
  sha256 "b01298806d494334b164011092d744dd8fcc4d8efabd43dce0f4178877aa1abc"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "63e47a712aad76d1397c5306358cc0be1f604a2e72128a8f9466d32c02421dce" => :catalina
    sha256 "3ed0a17b2af342f687e1770963f2382c56c8832cb8c344876d16fca33545962f" => :mojave
    sha256 "f19ef14ad929512fcc74204516fbf410c67aecc3f0eef54a550749483219ab44" => :high_sierra
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
