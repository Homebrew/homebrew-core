require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.25.tgz"
  sha256 "429aaf6528cbcf6c935e88706c7bfc0a1458fe2639b7087061ce156f5de70400"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7338bd79d307548c77bb7973709c6b933d7c3ce98c439073c076fe5c95a075e"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f2c8b48e528c812fe3ca0547edcbd9898d8b751eb05b4fb08589fc08c608f4f"
    sha256 cellar: :any_skip_relocation, catalina:      "3f2c8b48e528c812fe3ca0547edcbd9898d8b751eb05b4fb08589fc08c608f4f"
    sha256 cellar: :any_skip_relocation, mojave:        "3f2c8b48e528c812fe3ca0547edcbd9898d8b751eb05b4fb08589fc08c608f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7338bd79d307548c77bb7973709c6b933d7c3ce98c439073c076fe5c95a075e"
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
