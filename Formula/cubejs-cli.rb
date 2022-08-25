require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.57.tgz"
  sha256 "8c1be8217ae8ad1f870daf6c74434e6852ba3938a4e18cbb5c790a66d476940b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a15e5c4bbbf6d5400f7d731abf317b5742e4cb50eca684aa8aa6e4b3357f335"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a15e5c4bbbf6d5400f7d731abf317b5742e4cb50eca684aa8aa6e4b3357f335"
    sha256 cellar: :any_skip_relocation, monterey:       "f7bc64b781cf4d6a510a3ec87441c7bf2be042f692ece0fea9cd26f4ef48028b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7bc64b781cf4d6a510a3ec87441c7bf2be042f692ece0fea9cd26f4ef48028b"
    sha256 cellar: :any_skip_relocation, catalina:       "f7bc64b781cf4d6a510a3ec87441c7bf2be042f692ece0fea9cd26f4ef48028b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a15e5c4bbbf6d5400f7d731abf317b5742e4cb50eca684aa8aa6e4b3357f335"
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
