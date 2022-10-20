require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.4.tgz"
  sha256 "4924f2986db7e2e2c2e773c7650909f5f082944255ee5faa0fd683e88dfb61ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60ff6678f86d3fb526c144404080fe65e3141a6bd332617b3dab81266016a93d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60ff6678f86d3fb526c144404080fe65e3141a6bd332617b3dab81266016a93d"
    sha256 cellar: :any_skip_relocation, monterey:       "d839d0f6052b8a10729d3cbd312e6b4707313f8c9d39b72ee710b5f65178d69e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d839d0f6052b8a10729d3cbd312e6b4707313f8c9d39b72ee710b5f65178d69e"
    sha256 cellar: :any_skip_relocation, catalina:       "d839d0f6052b8a10729d3cbd312e6b4707313f8c9d39b72ee710b5f65178d69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60ff6678f86d3fb526c144404080fe65e3141a6bd332617b3dab81266016a93d"
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
