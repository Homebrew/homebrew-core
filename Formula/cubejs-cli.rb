require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.53.tgz"
  sha256 "31a4b1885b15f5c795cc021292c78f143833e6536afc793bed333bd92862f0f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6b1d562b1bc28bff6c86927ba6a1850b2af0ce1e316c99b676e597b307f6b45e"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a45dde39c378b09eb727f1a7482e2d6583f98ee184a538fded1e3fe2242f80e"
    sha256 cellar: :any_skip_relocation, catalina:      "5a45dde39c378b09eb727f1a7482e2d6583f98ee184a538fded1e3fe2242f80e"
    sha256 cellar: :any_skip_relocation, mojave:        "5a45dde39c378b09eb727f1a7482e2d6583f98ee184a538fded1e3fe2242f80e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c9138a8ed602eb8c1b9d2b42f51f4882fa9db4c4733350d8b14d462c6a87d6e"
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
