require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.20.tgz"
  sha256 "cc5e40b2f187e75cb875ce1cf91a61b9ed07c8b2eb6aca7a779265713033e034"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "924bded8590823f9aeb945157b015800981a8849ee3afcd4e16356b1e7f7a2a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "924bded8590823f9aeb945157b015800981a8849ee3afcd4e16356b1e7f7a2a8"
    sha256 cellar: :any_skip_relocation, monterey:       "4909146ff619f3bbb8dab18d0ecb811121fb5eda16abaebf011f7727692b100a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4909146ff619f3bbb8dab18d0ecb811121fb5eda16abaebf011f7727692b100a"
    sha256 cellar: :any_skip_relocation, catalina:       "4909146ff619f3bbb8dab18d0ecb811121fb5eda16abaebf011f7727692b100a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "924bded8590823f9aeb945157b015800981a8849ee3afcd4e16356b1e7f7a2a8"
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
