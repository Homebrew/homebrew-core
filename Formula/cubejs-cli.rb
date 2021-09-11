require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.33.tgz"
  sha256 "d9cdd892a1d1a7d5998a310ad1bdc3dce17322b3306e4bf7c37a747528ab8d8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3b0e7c25d73a8a7e107a96f934ac814ffdd2630318c22588828dca9d9f5dc7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "aadea24355bd29bb1a392aa80ccd523007690766558705d5a696217aea4600ac"
    sha256 cellar: :any_skip_relocation, catalina:      "aadea24355bd29bb1a392aa80ccd523007690766558705d5a696217aea4600ac"
    sha256 cellar: :any_skip_relocation, mojave:        "aadea24355bd29bb1a392aa80ccd523007690766558705d5a696217aea4600ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b0e7c25d73a8a7e107a96f934ac814ffdd2630318c22588828dca9d9f5dc7d"
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
