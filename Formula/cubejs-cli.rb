require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.43.tgz"
  sha256 "f698d07896ae4b5ff0ea1e853bcce62d07e80a1d32b9a6b4019e0532be705a41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5753346ad570d88ed9a52c50f3e5edcb357c0ee2ab9f1ecf489b9b41e78d5c37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5753346ad570d88ed9a52c50f3e5edcb357c0ee2ab9f1ecf489b9b41e78d5c37"
    sha256 cellar: :any_skip_relocation, monterey:       "cba9c67a071ecbf77fcb795e4e7fccb0a52332594ebf0f2c8053b2877041bdcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "cba9c67a071ecbf77fcb795e4e7fccb0a52332594ebf0f2c8053b2877041bdcf"
    sha256 cellar: :any_skip_relocation, catalina:       "cba9c67a071ecbf77fcb795e4e7fccb0a52332594ebf0f2c8053b2877041bdcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5753346ad570d88ed9a52c50f3e5edcb357c0ee2ab9f1ecf489b9b41e78d5c37"
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
