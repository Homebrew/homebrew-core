require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.25.tgz"
  sha256 "dcdbeb3eab1aaa4e40454f1053185045ca56be7f4cf28533794f65c6fa92c040"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9a6d4a45948c3049c5b2a39c48dafcc23dc5e126e1cf403bd8ed0c5e6940ab8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9a6d4a45948c3049c5b2a39c48dafcc23dc5e126e1cf403bd8ed0c5e6940ab8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9a6d4a45948c3049c5b2a39c48dafcc23dc5e126e1cf403bd8ed0c5e6940ab8"
    sha256 cellar: :any_skip_relocation, ventura:        "21e1bae4b3fdb490dbd5a4ab022f36103e8f4ebc5b9afab49d7301481765e4b4"
    sha256 cellar: :any_skip_relocation, monterey:       "21e1bae4b3fdb490dbd5a4ab022f36103e8f4ebc5b9afab49d7301481765e4b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "21e1bae4b3fdb490dbd5a4ab022f36103e8f4ebc5b9afab49d7301481765e4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9a6d4a45948c3049c5b2a39c48dafcc23dc5e126e1cf403bd8ed0c5e6940ab8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
