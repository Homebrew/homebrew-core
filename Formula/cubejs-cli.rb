require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.36.tgz"
  sha256 "d1ef5bfa9dcfb5886621b093964e3590a110e8388e4b4779e8d1d784547a978c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9485ece3fdf366550c4582c4429d4a40223b42022837fc0907a55f5328f11692"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7444502b187ef4e42f225cf38fd2b1195950b22708363f8847b44256b2ec600"
    sha256 cellar: :any_skip_relocation, catalina:      "e7444502b187ef4e42f225cf38fd2b1195950b22708363f8847b44256b2ec600"
    sha256 cellar: :any_skip_relocation, mojave:        "e7444502b187ef4e42f225cf38fd2b1195950b22708363f8847b44256b2ec600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9485ece3fdf366550c4582c4429d4a40223b42022837fc0907a55f5328f11692"
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
