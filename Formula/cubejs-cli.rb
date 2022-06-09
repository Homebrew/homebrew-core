require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.16.tgz"
  sha256 "68f1accf6d47fbf23b661c88e2dd749adfb7317aaa3387ace29a91460e4ee0ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4de550cac49fff670ac0bb5b28961b8dc0fed674c1d021e057374030767f20e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4de550cac49fff670ac0bb5b28961b8dc0fed674c1d021e057374030767f20e0"
    sha256 cellar: :any_skip_relocation, monterey:       "f7033017b5300f1067c849e9dba74576985d7a60379802e9416d183bf1f66444"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7033017b5300f1067c849e9dba74576985d7a60379802e9416d183bf1f66444"
    sha256 cellar: :any_skip_relocation, catalina:       "f7033017b5300f1067c849e9dba74576985d7a60379802e9416d183bf1f66444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4de550cac49fff670ac0bb5b28961b8dc0fed674c1d021e057374030767f20e0"
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
