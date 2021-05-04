require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.6.tgz"
  sha256 "f8f5c2ca613bfa186fd3987c8c0a726e600d840ef1b04d12358d1146a52eb820"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f0f7d00e6e0f8ef06913f50e3ce5b7ac7b5ddc14662df1857fc973177b5887b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d489165fa864844b916e846e960ec0695db46341d2dd377b5523969f846c6499"
    sha256 cellar: :any_skip_relocation, catalina:      "c9dec1e5eade33814aa8afee60916764331bcbbd24da29433bdfc34f4b4b41d3"
    sha256 cellar: :any_skip_relocation, mojave:        "efa66a641f4b489882e485d21d32ca67987ebcc6ab883113a47141e1a7aa300f"
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
