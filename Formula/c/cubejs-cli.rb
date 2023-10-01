require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.61.tgz"
  sha256 "47fe821ae862e0d86837ceebdf2fe143eeedc43a168cbdc0e2558677dcdcc123"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "eaa873b6745fd6af89ece860b1ce0203552b474b3983ac8f1117da2d508be2a8"
    sha256 cellar: :any, arm64_monterey: "eaa873b6745fd6af89ece860b1ce0203552b474b3983ac8f1117da2d508be2a8"
    sha256 cellar: :any, arm64_big_sur:  "eaa873b6745fd6af89ece860b1ce0203552b474b3983ac8f1117da2d508be2a8"
    sha256 cellar: :any, ventura:        "aa2b82bc609131e940a646e0bc018bac36c48dc3e257d96215e7bbd9c9bb58b5"
    sha256 cellar: :any, monterey:       "22e704860f2ce3f40f083eeec34668c4eceaead5e42512038fc86b9abef2ca95"
    sha256 cellar: :any, big_sur:        "22e704860f2ce3f40f083eeec34668c4eceaead5e42512038fc86b9abef2ca95"
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
