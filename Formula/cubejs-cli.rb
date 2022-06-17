require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.25.tgz"
  sha256 "01a8b814f71fe1aaf6d30070b90117fc68a507e7b0e9807f6142cf9e0c2fe051"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "203ed5e4bc90c005a197df692094ee9664ad3840e6ebe8e2b8a8b86bfbd4241e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "203ed5e4bc90c005a197df692094ee9664ad3840e6ebe8e2b8a8b86bfbd4241e"
    sha256 cellar: :any_skip_relocation, monterey:       "8fd35254558c7731c17914d0be131f9bdcb87862c4186fa18c3a5958cbc9c82f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fd35254558c7731c17914d0be131f9bdcb87862c4186fa18c3a5958cbc9c82f"
    sha256 cellar: :any_skip_relocation, catalina:       "8fd35254558c7731c17914d0be131f9bdcb87862c4186fa18c3a5958cbc9c82f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "203ed5e4bc90c005a197df692094ee9664ad3840e6ebe8e2b8a8b86bfbd4241e"
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
