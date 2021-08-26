require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.28.tgz"
  sha256 "c76c06b9282b7bc17e3f2e118e7853175d14d2ba18abbf96e57da0a61540ea14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5340de5c4a90efac187522b90ef2084e0db8fa31cc4aab3d44bed640e0aa64fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "10da58f15d62f43db3aa5d7356f24662019c543ba667c891f0ed056fc55fa18f"
    sha256 cellar: :any_skip_relocation, catalina:      "10da58f15d62f43db3aa5d7356f24662019c543ba667c891f0ed056fc55fa18f"
    sha256 cellar: :any_skip_relocation, mojave:        "10da58f15d62f43db3aa5d7356f24662019c543ba667c891f0ed056fc55fa18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5340de5c4a90efac187522b90ef2084e0db8fa31cc4aab3d44bed640e0aa64fb"
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
