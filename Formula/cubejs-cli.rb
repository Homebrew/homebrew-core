require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.15.tgz"
  sha256 "cc6ec742081abb47d35d19a7fe8282258992197946a7dee4e03ee900fae83ec9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15a197cff08f6600aa7bfc572577c899c834ebcb93ee529b43c6395dc5f11a1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15a197cff08f6600aa7bfc572577c899c834ebcb93ee529b43c6395dc5f11a1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15a197cff08f6600aa7bfc572577c899c834ebcb93ee529b43c6395dc5f11a1b"
    sha256 cellar: :any_skip_relocation, monterey:       "f25947d9b4796a8374c1ca6dad7e43dad165c01418cce9981ca542def57bbdfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f25947d9b4796a8374c1ca6dad7e43dad165c01418cce9981ca542def57bbdfc"
    sha256 cellar: :any_skip_relocation, catalina:       "f25947d9b4796a8374c1ca6dad7e43dad165c01418cce9981ca542def57bbdfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15a197cff08f6600aa7bfc572577c899c834ebcb93ee529b43c6395dc5f11a1b"
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
