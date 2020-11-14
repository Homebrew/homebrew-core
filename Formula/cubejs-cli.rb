require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.23.11.tgz"
  sha256 "3450f8a36eb07c1ec63e17ececa3cefe599ebe992798153ee62d705b8c4abb0d"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "eac28cdc432422b67f483c9fa3a8d69d7a978d0f18733e328b4dddc92157d5ef" => :catalina
    sha256 "882850bb43f63caf07aa2f6c4746b9e46d022e23dae957967e437ebf8e467211" => :mojave
    sha256 "ff4e8077ca66bb148dad8b02ac917f732dbbb13a060d2fc5fa0cda1eca202aba" => :high_sierra
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
