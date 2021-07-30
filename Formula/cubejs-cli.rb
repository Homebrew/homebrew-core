require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.10.tgz"
  sha256 "87bc84e18d093f062f7d194a4e279ffd3d91ea1dfebb73d8eb79b7259b77e4d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1aa41da5b835671fc25e1aa1d523969734e1c58ed6b0f2088ea6a5835e487ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "62cfd9f97df38148d333a64e02b98736dedf84c6b7a3f0a029ed83bdfa166714"
    sha256 cellar: :any_skip_relocation, catalina:      "62cfd9f97df38148d333a64e02b98736dedf84c6b7a3f0a029ed83bdfa166714"
    sha256 cellar: :any_skip_relocation, mojave:        "62cfd9f97df38148d333a64e02b98736dedf84c6b7a3f0a029ed83bdfa166714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1aa41da5b835671fc25e1aa1d523969734e1c58ed6b0f2088ea6a5835e487ad"
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
