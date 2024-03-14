require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.0.tgz"
  sha256 "d778c058410518c6b581ea3d798ce85c42467e70bf3ec5e018696a94ee76b90d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2f28ea9d6156f36e289da991e7f0b116c8a7bfa9b2c435a6d1950ab5be804ead"
    sha256 cellar: :any, arm64_ventura:  "2f28ea9d6156f36e289da991e7f0b116c8a7bfa9b2c435a6d1950ab5be804ead"
    sha256 cellar: :any, arm64_monterey: "2f28ea9d6156f36e289da991e7f0b116c8a7bfa9b2c435a6d1950ab5be804ead"
    sha256 cellar: :any, sonoma:         "a0c1acfa2ef52c157982a59295a80a84d37c0fd814c7c4e36eed32c6646be756"
    sha256 cellar: :any, ventura:        "a0c1acfa2ef52c157982a59295a80a84d37c0fd814c7c4e36eed32c6646be756"
    sha256 cellar: :any, monterey:       "a0c1acfa2ef52c157982a59295a80a84d37c0fd814c7c4e36eed32c6646be756"
  end

  depends_on "node"
  uses_from_macos "zlib"

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
