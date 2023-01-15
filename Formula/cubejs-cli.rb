require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.42.tgz"
  sha256 "6bf85415073269d2368c1bf75f7468607c0d4f92c752aa67e51d210ad9d8de93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7235ed670c0911178af427c65f9491247fdcd352e064c74224e4e5301c95b218"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7235ed670c0911178af427c65f9491247fdcd352e064c74224e4e5301c95b218"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7235ed670c0911178af427c65f9491247fdcd352e064c74224e4e5301c95b218"
    sha256 cellar: :any_skip_relocation, ventura:        "e7bf621212ecc693e3ccdd3469dc4d60619cc8c60c2a8eb994fd63552f4a8f77"
    sha256 cellar: :any_skip_relocation, monterey:       "e7bf621212ecc693e3ccdd3469dc4d60619cc8c60c2a8eb994fd63552f4a8f77"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7bf621212ecc693e3ccdd3469dc4d60619cc8c60c2a8eb994fd63552f4a8f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7235ed670c0911178af427c65f9491247fdcd352e064c74224e4e5301c95b218"
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
