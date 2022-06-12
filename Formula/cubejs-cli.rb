require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.20.tgz"
  sha256 "cc5e40b2f187e75cb875ce1cf91a61b9ed07c8b2eb6aca7a779265713033e034"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d9f936b27ef0d74f89a0d3ca77b443abb0b1315990fe6b566d2c1ba0c6961a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3d9f936b27ef0d74f89a0d3ca77b443abb0b1315990fe6b566d2c1ba0c6961a"
    sha256 cellar: :any_skip_relocation, monterey:       "00dc7a4ca21333f80bc68b8e8d0bce9b1808b3d79dc2ed3da6a99abfe0d8340e"
    sha256 cellar: :any_skip_relocation, big_sur:        "00dc7a4ca21333f80bc68b8e8d0bce9b1808b3d79dc2ed3da6a99abfe0d8340e"
    sha256 cellar: :any_skip_relocation, catalina:       "00dc7a4ca21333f80bc68b8e8d0bce9b1808b3d79dc2ed3da6a99abfe0d8340e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3d9f936b27ef0d74f89a0d3ca77b443abb0b1315990fe6b566d2c1ba0c6961a"
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
