require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.26.tgz"
  sha256 "155faa0ded557d1c1fb71b564d83e0add239bade1897752468b03ba1eef97efe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89c8bba2a2413cc8bf5450a4d30382724994e85dda8f4e42905459a2bd78e818"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c8bba2a2413cc8bf5450a4d30382724994e85dda8f4e42905459a2bd78e818"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89c8bba2a2413cc8bf5450a4d30382724994e85dda8f4e42905459a2bd78e818"
    sha256 cellar: :any_skip_relocation, ventura:        "7a077fd6731b4a3a2c9165445995898b0ba0043bcde7193cf72de80206de4017"
    sha256 cellar: :any_skip_relocation, monterey:       "7a077fd6731b4a3a2c9165445995898b0ba0043bcde7193cf72de80206de4017"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a077fd6731b4a3a2c9165445995898b0ba0043bcde7193cf72de80206de4017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c8bba2a2413cc8bf5450a4d30382724994e85dda8f4e42905459a2bd78e818"
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
