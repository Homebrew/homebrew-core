require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.12.tgz"
  sha256 "ed993cf1fd32ac0ec60ff864fff0a275b6294daa603bcfb94651c99a0bd9e20a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d29e48a00f8117afdc09ba572503c4b765dcbae1ca9144bfb5e9ed02f160434a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d29e48a00f8117afdc09ba572503c4b765dcbae1ca9144bfb5e9ed02f160434a"
    sha256 cellar: :any_skip_relocation, monterey:       "f92a4b4751890085ec214f80427a0e3f8cc353e6e526dfc003637bc7f31737a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f92a4b4751890085ec214f80427a0e3f8cc353e6e526dfc003637bc7f31737a8"
    sha256 cellar: :any_skip_relocation, catalina:       "f92a4b4751890085ec214f80427a0e3f8cc353e6e526dfc003637bc7f31737a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d29e48a00f8117afdc09ba572503c4b765dcbae1ca9144bfb5e9ed02f160434a"
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
