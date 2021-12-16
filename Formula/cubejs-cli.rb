require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.4.tgz"
  sha256 "6e90c738686931c5c2855f4b7b032e0b3f7197ae67dfee3c68c004b01802a747"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "976702be613034d3386481b9d45264984ce8420edb4bcb203d8b81aa13e093da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "976702be613034d3386481b9d45264984ce8420edb4bcb203d8b81aa13e093da"
    sha256 cellar: :any_skip_relocation, monterey:       "67779d5281afc17a478f8e955e7accb0fddb963d26b524d103ef5fe80e6d8ec7"
    sha256 cellar: :any_skip_relocation, big_sur:        "67779d5281afc17a478f8e955e7accb0fddb963d26b524d103ef5fe80e6d8ec7"
    sha256 cellar: :any_skip_relocation, catalina:       "67779d5281afc17a478f8e955e7accb0fddb963d26b524d103ef5fe80e6d8ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "976702be613034d3386481b9d45264984ce8420edb4bcb203d8b81aa13e093da"
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
