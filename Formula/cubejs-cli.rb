require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.24.tgz"
  sha256 "4c95b71517d2cbe32038a444d140f107deeec9628ab4c05a54c30330a5d901b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a21e4cebb8dfb6f40a90e7e0e4c3e88701f6303712f6a83bd084119a12dca6cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a21e4cebb8dfb6f40a90e7e0e4c3e88701f6303712f6a83bd084119a12dca6cc"
    sha256 cellar: :any_skip_relocation, monterey:       "abec2d6c0328471c4ca51be283c20a2cde6aceb8a72795a37f52e16512bd0d6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "abec2d6c0328471c4ca51be283c20a2cde6aceb8a72795a37f52e16512bd0d6b"
    sha256 cellar: :any_skip_relocation, catalina:       "abec2d6c0328471c4ca51be283c20a2cde6aceb8a72795a37f52e16512bd0d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a21e4cebb8dfb6f40a90e7e0e4c3e88701f6303712f6a83bd084119a12dca6cc"
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
