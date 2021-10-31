require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.51.tgz"
  sha256 "6acf66341b38485f03e68559490e13b45af9b3a4cb042cda96a4c64aabd6f087"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "588fac570eb1d730582f68f373057121057a5ce190f82aab0bc35ed11887bb59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ed0019831d9acb42fa5508cf725a38400582282a54da6cac2d9bf471e83d5dd"
    sha256 cellar: :any_skip_relocation, monterey:       "8b11208c4117d8b5e521c57c18e15604867cab2d7d068380ed5d4f912afdfad7"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd56a0db2a5c4887482d1d2e8a26104afef1b68d8a90c6e3d5ef24b662d83b0b"
    sha256 cellar: :any_skip_relocation, catalina:       "cd56a0db2a5c4887482d1d2e8a26104afef1b68d8a90c6e3d5ef24b662d83b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ed0019831d9acb42fa5508cf725a38400582282a54da6cac2d9bf471e83d5dd"
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
