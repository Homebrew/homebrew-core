require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.32.tgz"
  sha256 "38c04f3efd79fda27fcc75ea7f66abec4d2061d5c275306ebe96b9a3f692585f"
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
