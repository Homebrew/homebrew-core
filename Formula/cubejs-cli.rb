require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.32.tgz"
  sha256 "38c04f3efd79fda27fcc75ea7f66abec4d2061d5c275306ebe96b9a3f692585f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84a5ec36411b3fd1136c871a69ffd18fe175077dbd845e77c7b7aa4ee5b960d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "2680bc78509f246ba9ce34fddd734daafcc109038a190dd26107d941d8361c85"
    sha256 cellar: :any_skip_relocation, catalina:      "2680bc78509f246ba9ce34fddd734daafcc109038a190dd26107d941d8361c85"
    sha256 cellar: :any_skip_relocation, mojave:        "2680bc78509f246ba9ce34fddd734daafcc109038a190dd26107d941d8361c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84a5ec36411b3fd1136c871a69ffd18fe175077dbd845e77c7b7aa4ee5b960d8"
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
