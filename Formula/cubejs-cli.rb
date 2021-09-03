require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.31.tgz"
  sha256 "b04b5414671c2a1645f7a3f7bed060535ecd6264a04a4273167cfc109935d9a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "705fb4be57143b7cd808641250bd830a38f51c4107ffd4ed12ed275ad3e16fbf"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6e445195a57ce67be15a277000754eb03d919ada61b2b9480eb0e6bf6fc9d69"
    sha256 cellar: :any_skip_relocation, catalina:      "a6e445195a57ce67be15a277000754eb03d919ada61b2b9480eb0e6bf6fc9d69"
    sha256 cellar: :any_skip_relocation, mojave:        "a6e445195a57ce67be15a277000754eb03d919ada61b2b9480eb0e6bf6fc9d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "705fb4be57143b7cd808641250bd830a38f51c4107ffd4ed12ed275ad3e16fbf"
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
