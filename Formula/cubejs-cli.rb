require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.2.tgz"
  sha256 "a9795fad3ef386df073c97e5f0af23be626fa4e276a4b257e58c9c6b38f66fce"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db23bb7ece8e56e2c9e6071bd23b157b4ae510d1bcae0dd3782693f491574699"
    sha256 cellar: :any_skip_relocation, big_sur:       "823b4dd4056cf99a6b99704ce705faf87865f123aa73341b2b738a6bb1d9dce1"
    sha256 cellar: :any_skip_relocation, catalina:      "a37f717a7995abb6e5e5ddfaf1f5b1cba9c887d2a5b57142b8d3f9c428673319"
    sha256 cellar: :any_skip_relocation, mojave:        "8589cecc0fdaa682719f729d744a33c1df7d2e97a27291b58fb87dd0f3d6a345"
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
