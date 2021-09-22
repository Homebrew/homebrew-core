require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.39.tgz"
  sha256 "4f932b434edf318fac16e3694d7a054b325af29d31ab296fa125e6787dde2381"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5b4ca727c3ad905dafbbfa76ab1dfa0adfd9ce6c58df43c2683aa0fd0a3050cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "9fb2c43eb183e279667386e4065fbe7963d76e429554fdf3aed1cc935a72d396"
    sha256 cellar: :any_skip_relocation, catalina:      "9fb2c43eb183e279667386e4065fbe7963d76e429554fdf3aed1cc935a72d396"
    sha256 cellar: :any_skip_relocation, mojave:        "9fb2c43eb183e279667386e4065fbe7963d76e429554fdf3aed1cc935a72d396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b4ca727c3ad905dafbbfa76ab1dfa0adfd9ce6c58df43c2683aa0fd0a3050cc"
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
