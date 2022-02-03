require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.25.tgz"
  sha256 "8bc1b645814a3c9c0b13656f12a359c0286a3294b00c36b146f4abfc807bdd0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fac82b801bcb203383e71f00da9e68d63f3d74c0ebd71a1647538374da26485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fac82b801bcb203383e71f00da9e68d63f3d74c0ebd71a1647538374da26485"
    sha256 cellar: :any_skip_relocation, monterey:       "751cf077917fc183f2ca243375fa778b5d3b810160c249603b17bb388f770e85"
    sha256 cellar: :any_skip_relocation, big_sur:        "751cf077917fc183f2ca243375fa778b5d3b810160c249603b17bb388f770e85"
    sha256 cellar: :any_skip_relocation, catalina:       "751cf077917fc183f2ca243375fa778b5d3b810160c249603b17bb388f770e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fac82b801bcb203383e71f00da9e68d63f3d74c0ebd71a1647538374da26485"
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
