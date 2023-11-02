require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.13.tgz"
  sha256 "cec613d59d38d49efa8d2699d5d1742d6e1b4e8168c252679dac2243c661dfdf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "210fdcc56428e45948a916757e2080434c9eae74fc16ae85a17963da923c6d89"
    sha256 cellar: :any, arm64_ventura:  "210fdcc56428e45948a916757e2080434c9eae74fc16ae85a17963da923c6d89"
    sha256 cellar: :any, arm64_monterey: "210fdcc56428e45948a916757e2080434c9eae74fc16ae85a17963da923c6d89"
    sha256 cellar: :any, sonoma:         "5d2f66f35b9ec90f84fe093ab37893355e80add6fecd138e316e4229168e8164"
    sha256 cellar: :any, ventura:        "5d2f66f35b9ec90f84fe093ab37893355e80add6fecd138e316e4229168e8164"
    sha256 cellar: :any, monterey:       "5d2f66f35b9ec90f84fe093ab37893355e80add6fecd138e316e4229168e8164"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
