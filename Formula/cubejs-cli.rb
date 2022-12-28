require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.32.tgz"
  sha256 "980a86bb552c1b74c935880874ab3892df7f79ffcff857ce4ddd3b80eed0eb4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4b600eddbb1d6cca674579ea2c56697d7d61b7e12b434ff745520afebf5a6f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4b600eddbb1d6cca674579ea2c56697d7d61b7e12b434ff745520afebf5a6f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4b600eddbb1d6cca674579ea2c56697d7d61b7e12b434ff745520afebf5a6f0"
    sha256 cellar: :any_skip_relocation, ventura:        "d787a946e931b1b9ce71ce3f91e5efd2d6aceb0c3c75fa36982b34290a14543f"
    sha256 cellar: :any_skip_relocation, monterey:       "d787a946e931b1b9ce71ce3f91e5efd2d6aceb0c3c75fa36982b34290a14543f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d787a946e931b1b9ce71ce3f91e5efd2d6aceb0c3c75fa36982b34290a14543f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b600eddbb1d6cca674579ea2c56697d7d61b7e12b434ff745520afebf5a6f0"
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
